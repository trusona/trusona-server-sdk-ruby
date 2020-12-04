# frozen_string_literal: true

require 'json'

module Trusona
  module Api
    #
    ## A HMAC message suitable for authorization to the Trusona API
    class HashedMessage
      def initialize(params = {})
        validate(params)

        @method       = params[:method]
        @body         = params[:body]
        @content_type = params[:content_type]
        @path         = params[:path]
        @date         = params[:date]
        @secret       = Trusona.config.secret
        @token        = Trusona.config.token
      end

      def auth_header
        "TRUSONA #{@token}:#{signature}"
      end

      def signature
        Base64.strict_encode64(
          OpenSSL::HMAC.hexdigest(
            OpenSSL::Digest.new('SHA256'), @secret, prepare_data
          )
        )
      end

      private

      def body_digest
        digestable_body = ''
        digestable_body = @body unless @body.nil? || @body.empty?

        OpenSSL::Digest.new('MD5').hexdigest(digestable_body)
      end

      def invalid_param?(param)
        param.nil?
      end

      def invalid_method?(method)
        http_methods = %w[GET POST DELETE PATCH PUT]
        return true if invalid_param?(method)
        return true unless http_methods.include?(method.strip.upcase)
      end

      def prepare_data
        data = [
          @method.to_s,
          body_digest,
          @content_type,
          @date,
          @path
        ]

        data.join("\n")
      end

      def validate(params)
        raise ArgumentError if invalid_method?(params[:method])
        raise ArgumentError if invalid_param?(params[:path])
      end
    end
  end
end
