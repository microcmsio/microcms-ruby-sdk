# frozen_string_literal: true

require 'microcms/version'
require 'net/http'
require 'uri'
require 'json'
require 'forwardable'

# MicroCMS
module MicroCMS
  class << self
    extend Forwardable

    attr_accessor :api_key, :service_domain

    delegate %i[list get create update delete] => :client

    def client
      Client.new(@service_domain, @api_key)
    end
  end

  # HttpUtil
  module HttpUtil
    def send_http_request(method, endpoint, path, query = nil, body = nil)
      uri = build_uri(endpoint, path, query)
      http = build_http(uri)
      req = build_request(method, uri, body)
      res = http.request(req)

      raise APIError.new(status_code: res.code.to_i, body: res.body) if res.code.to_i >= 400

      JSON.parse(res.body, object_class: OpenStruct) if res.header['Content-Type'].include?('application/json') # rubocop:disable Style/OpenStructUse
    end

    private

    def get_request_class(method)
      {
        GET: Net::HTTP::Get,
        POST: Net::HTTP::Post,
        PUT: Net::HTTP::Put,
        PATCH: Net::HTTP::Patch,
        DELETE: Net::HTTP::Delete
      }[method]
    end

    def build_request(method, uri, body)
      req = get_request_class(method.to_sym).new(uri.request_uri)
      req['X-MICROCMS-API-KEY'] = @api_key
      if body
        req['Content-Type'] = 'application/json'
        req.body = JSON.dump(body)
      end

      req
    end

    def build_uri(endpoint, path, query)
      origin = "https://#{@service_domain}.microcms.io"
      path_with_id = path ? "/api/v1/#{endpoint}/#{path}" : "/api/v1/#{endpoint}"
      encoded_query =
        if !query || query.size.zero?
          ''
        else
          "?#{URI.encode_www_form(query)}"
        end

      URI.parse("#{origin}#{path_with_id}#{encoded_query}")
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      http
    end
  end

  # Client
  class Client
    include HttpUtil

    def initialize(service_domain, api_key)
      @service_domain = service_domain
      @api_key = api_key
    end

    def list(endpoint, option = {})
      list = send_http_request('GET', endpoint, nil, build_query(option))
      if list[:totalCount]
        list[:total_count] = list[:totalCount]
        list.delete_field(:totalCount)
      end
      list
    end

    def get(endpoint, id = '', option = {})
      send_http_request(
        'GET',
        endpoint,
        id,
        {
          draftKey: option[:draft_key],
          fields: option[:fields] ? option[:fields].join(',') : nil,
          depth: option[:depth]
        }.select { |_key, value| value }
      )
    end

    def create(endpoint, content, option = {})
      if content[:id]
        put(endpoint, content, option)
      else
        post(endpoint, content, option)
      end
    end

    def update(endpoint, content)
      body = content.reject { |key, _value| key == :id }
      send_http_request('PATCH', endpoint, content[:id], nil, body)
    end

    def delete(endpoint, id)
      send_http_request('DELETE', endpoint, id)
    end

    private

    # rubocop:disable Style/MethodLength
    def build_query(option)
      {
        draftKey: option[:draftKey],
        limit: option[:limit],
        offset: option[:offset],
        orders: option[:orders] ? option[:orders].join(',') : nil,
        q: option[:q],
        fields: option[:fields] ? option[:fields].join(',') : nil,
        filters: option[:filters],
        depth: option[:depth],
        ids: option[:ids] ? option[:ids].join(',') : nil
      }.select { |_key, value| value }
    end
    # rubocop:enable Style/MethodLength

    def put(endpoint, content, option = {})
      body = content.reject { |key, _value| key == :id }
      send_http_request('PUT', endpoint, content[:id], option, body)
    end

    def post(endpoint, content, option = {})
      send_http_request('POST', endpoint, nil, option, content)
    end
  end

  # APIError
  class APIError < StandardError
    attr_accessor :status_code, :body

    def initialize(status_code:, body:)
      @status_code = status_code
      @body = parse_body(body)

      message = @body['message'] || 'Unknown error occured.'
      super(message)
    end

    def inspect
      "#<#{self.class.name} @status_code=#{status_code}, @body=#{body.inspect} @message=#{message.inspect}>"
    end

    private

    def parse_body(body)
      JSON.parse(body)
    rescue JSON::ParserError
      {}
    end
  end
end
