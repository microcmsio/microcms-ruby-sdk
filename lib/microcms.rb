# frozen_string_literal: true

require 'microcms/version'
require 'net/http'
require 'uri'
require 'json'

# MicroCMS
module MicroCMS
  # Client
  class Client
    def initialize(service_domain, api_key)
      @service_domain = service_domain
      @api_key = api_key
    end

    def list(endpoint, option = {})
      send_http_request('GET', endpoint, nil, build_query(option))
    end

    def get(endpoint, id = '', option = {})
      send_http_request(
        'GET',
        endpoint,
        id,
        {
          draftKey: option[:draftKey],
          fields: option[:fields] ? option[:fields].join(',') : nil,
          depth: option[:depth]
        }.select { |_key, value| value }
      )
    end

    def create(endpoint, option)
      if option[:id]
        put(endpoint, option)
      else
        post(endpoint, option)
      end
    end

    def update(endpoint, option)
      body = option.reject { |key, _value| key == :id }
      send_http_request('PATCH', endpoint, option[:id], nil, body)
    end

    def delete(endpoint, _id)
      send_http_request('DELETE', endpoint, id)
    end

    private

    def build_query(option)
      {
        draftKey: option[:draftKey],
        limit: option[:limit],
        offset: option[:offset],
        orders: option[:orders] ? option[:orders].join(',') : nil,
        q: option[:q],
        fields: option[:fields] ? option[:fields].join(',') : nil,
        filters: option[:filters],
        depth: option[:depth]
      }.select { |_key, value| value }
    end

    def put(endpoint, option)
      body = option.reject { |key, _value| key == :id }
      send_http_request('PUT', endpoint, option[:id], nil, body)
    end

    def post(endpoint, option)
      send_http_request('POST', endpoint, nil, nil, option)
    end

    def send_http_request(method, _endpoint, path, query = {}, _body = nil)
      uri = build_uri(path, query)
      http = build_http(uri)
      req = build_request(method, uri)
      res = http.request(req)

      raise "HTTP Errror: Status is #{res.code}, Body is #{res.body}" if res.code.to_i >= 400

      JSON.parse(res.body, object_class: OpenStruct) if res.header['Content-Type'].include?('application/json')
    end

    @request_class = {
      GET: Net::HTTP::Get,
      POST: Net::HTTP::Post,
      PUT: Net::HTTP::Put,
      PATCH: Net::HTTP::Patch,
      DELETE: Net::HTTP::Delete
    }

    def build_request(method, uri)
      req = @request_class[method.to_sym].new(uri.request_uri)
      req['X-MICROCMS-API-KEY'] = @api_key
      if body
        req['Content-Type'] = 'application/json'
        req.body = JSON.dump(body)
      end

      req
    end

    def build_uri(path, query)
      origin = "https://#{@service_domain}.microcms.io"
      path_with_prefix = "/api/v1/#{@api_name}/#{path}"
      encoded_query =
        if query
          "?#{URI.encode_www_form(query)}"
        else
          ''
        end

      URI.parse("#{origin}#{path_with_prefix}#{encoded_query}")
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      http
    end
  end
end
