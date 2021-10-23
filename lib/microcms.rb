require "microcms/version"
require "net/http"
require "uri"
require "json"

module MicroCMS
  class << self
    attr_accessor :api_key
    attr_accessor :service_domain

    def method_missing(name, *args, &block)
      APIClient.new(@service_domain, name, @api_key)
    end
  end

  class APIClient
    def initialize(service_domain, api_name, api_key)
      @service_domain = service_domain
      @api_name = api_name
      @api_key = api_key
    end

    def list(option = {})
      send_http_request(
        "GET",
        nil,
        {
          draftKey: option[:draftKey],
          limit: option[:limit],
          offset: option[:offset],
          orders: if option[:orders] then option[:orders].join(',') else nil end,
          q: option[:q],
          fields: if option[:fields] then option[:fields].join(',') else nil end,
          filters: option[:filters],
          depth: option[:depth],
        }.select { |key, value| value }
      )
    end

    def get(id, option = {})
      send_http_request(
        "GET",
        id,
        {
          draftKey: option[:draftKey],
          fields: if option[:fields] then option[:fields].join(',') else nil end,
          depth: option[:depth],
        }.select { |key, value| value }
      )
    end

    def create(option)
      if option[:id]
        send_http_request(
          "PUT",
          option[:id],
          nil,
          option.reject { |key, value| key == :id }
        )
      else
        send_http_request(
          "POST",
          nil,
          nil,
          option,
        )
      end
    end

    def update(option)
      send_http_request(
        "PATCH",
        option[:id],
        nil,
        option.reject { |key, value| key == :id },
      )
    end

    def delete(id)
      send_http_request("DELETE", id)
    end

    private
      def send_http_request(method = "GET", path = "", query = {}, body = nil)
        origin = "https://#{@service_domain}.microcms.io"
        path_with_prefix = "/api/v1/#{@api_name}/#{path}"
        encoded_query =
          if query
            "?#{URI.encode_www_form(query)}"
          else
            ""
          end
        uri = URI.parse("#{origin}#{path_with_prefix}#{encoded_query}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request_class = {
          GET: Net::HTTP::Get,
          POST: Net::HTTP::Post,
          PUT: Net::HTTP::Put,
          PATCH: Net::HTTP::Patch,
          DELETE: Net::HTTP::Delete,
        }

        req = request_class[method.to_sym].new(uri.request_uri)
        req["X-MICROCMS-API-KEY"] = @api_key
        if body
          req["Content-Type"] = "application/json"
          req.body = JSON.dump(body)
        end

        res = http.request(req)

        raise "HTTP Errror: Status is #{res.code}, Body is #{res.body}" if res.code.to_i >= 400

        JSON.parse(res.body, object_class: OpenStruct) if res.header["Content-Type"].include?("application/json")
      end
  end
end
