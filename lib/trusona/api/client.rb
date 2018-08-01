# frozen_string_literal: true

module Trusona
  module Api
    #
    ## An a wrapper around HTTParty
    class HTTPClient
      POST   = 'POST'
      GET    = 'GET'
      PATCH  = 'PATCH'
      DELETE = 'DELETE'

      CONTENT_TYPE = 'application/json;charset=utf-8'

      def initialize(host = nil)
        @host = host || Trusona.config.api_host
      end

      def post(path, params = {})
        execute(path, params, POST)
      end

      def patch(path, params = {})
        execute(path, params, PATCH)
      end

      def get(path, params = {})
        execute(path, params, GET)
      end

      def delete(path, params = {})
        execute(path, params, DELETE)
      end

      private

      def execute(path, params, method)
        request = Trusona::Api::SignedRequest.new(path, params, method, @host)

        # Power of ruby or hard to read?
        unverified = HTTParty.send(
          method.downcase,
          request.uri,
          body: request.body,
          headers: request.headers
        )

        Trusona::Api::VerifiedResponse.new(unverified)
      end
    end

    ##
    # A default nil http client
    class NilHTTPClient
      def initialize(host)
        @host = host
      end

      def post(_uri, _params); end

      def get(_uri, _params); end

      def patch(_uri, _params); end
    end
  end
end
