# frozen_string_literal: true

module Trusona
  module Api
    #
    ## a response from the Trusona API that can be verified with HMAC
    class VerifiedResponse
      LEGACY_SERVER_HEADER = 'Apache-Coyote/1.1'
      attr_reader :code

      def initialize(unverified)
        @unverified = unverified
        @verified   = verify
        @code = unverified.code
      end

      def to_h
        JSON.parse(@unverified.body) rescue {}
      end

      def verified?
        @verified
      end

      private

      def verify
        expected = expected_signature
        actual = @unverified.headers['X-Signature']
        actual == expected || actual == Base64.strict_decode64(expected)
      end

      # rubocop:disable Metrics/MethodLength
      def expected_signature
        begin
          message = Trusona::Api::HashedMessage.new(
            method: parse_method(@unverified.request.http_method),
            body: @unverified.body,
            content_type: determine_content_type,
            path: parse_path(@unverified.request.uri),
            date: parse_date(@unverified.headers)
          )
        rescue ArgumentError
          raise Trusona::SigningError
        end

        message.signature
      end
      # rubocop:enable Metrics/MethodLength

      def parse_path(uri)
        return uri.path unless uri.query
        [uri.path, uri.query].join('?')
      end

      def parse_date(headers)
        headers['X-Date'] || headers['x-date'] || headers['Date']
      end

      def determine_content_type
        server = @unverified.headers['server']
        response_type = @unverified.headers['Content-Type']
        return response_type unless server == LEGACY_SERVER_HEADER
        determine_request_content_type
      end

      def determine_request_content_type
        default_type = 'application/json;charset=utf-8'
        return default_type unless @unverified.request
        return default_type unless @unverified.request.options
        return default_type unless @unverified.request.options[:headers]
        @unverified.request.options[:headers]['Content-Type']
      end

      def parse_method(method)
        method::METHOD
      end
    end
  end
end
