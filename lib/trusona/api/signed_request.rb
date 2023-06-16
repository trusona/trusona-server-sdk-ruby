# frozen_string_literal: true

module Trusona
  module Api
    #
    ## A signed request that can be used to make HMAC'd API calls to Trusona
    class SignedRequest
      attr_reader :uri, :body

      def initialize(path, body, method, host)
        @host = host
        @uri  = build_uri(path, body)
        @body = parse_body(body)
        @path = build_path(path)
        @method = method
        @headers = { 'x-date' => nil, 'Authorization' => nil }
        @date = Time.now.httpdate
        validate
        @signature = sign
      end

      def headers
        @headers.merge(
          'x-date' => @date,
          'Date' => @date,
          'X-Date' => @date,
          'Authorization' => @signature,
          'Content-Type' => determine_content_type
        )
      end

      private

      def determine_content_type
        return '' if @method == 'GET' || @method == 'DELETE'

        Trusona::Api::HTTPClient::CONTENT_TYPE
      end

      def build_path(path)
        return path if @uri.query.nil? || @uri.query.empty?

        [@uri.path, @uri.query].join('?')
      end

      def build_uri(path, body)
        return build_uri_with_query(URI(path)) if URI(path).query
        return build_uri_with_body_as_query(path, body) if valid_hash_body(body)

        URI::HTTPS.build(host: @host, path:)
      end

      def valid_hash_body(body)
        body.is_a?(Hash) && !body.empty?
      end

      def parse_body(body)
        body.is_a?(Hash) ? '' : body
      end

      def sign
        message = Trusona::Api::HashedMessage.new(
          body: @body,
          content_type: determine_content_type,
          path: @path,
          method: @method,
          date: @date
        )

        message.auth_header
      rescue ArgumentError
        raise Trusona::SigningError
      end

      def build_uri_with_query(generic)
        URI::HTTPS.build(
          host: @host,
          path: generic.path,
          query: generic.query
        )
      end

      def build_uri_with_body_as_query(path, body)
        URI::HTTPS.build(
          host: @host,
          path:,
          query: URI.encode_www_form(body)
        )
      end

      def validate
        raise ArgumentError unless @path
        raise ArgumentError unless @body
        raise ArgumentError unless @method
        raise ArgumentError unless @host
      end
    end
  end
end
