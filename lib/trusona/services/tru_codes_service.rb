# frozen_string_literal: true

module Trusona
  module Services
    #
    ## A service for interacting with TruCode TruCodes
    class TruCodesService < BaseService
      def initialize(
        client: Trusona::Api::HTTPClient.new(Trusona.config.tru_codes_host),
        mapper: Trusona::Mappers::TruCodeMapper.new
      )
        @client = client
        @mapper = mapper
        @resource_path = '/api/v2/trucodes'
      end

      def member_path(resource)
        [@resource_path, resource.id].join('/')
      end

      def verify_response(_response)
        true
      end
    end
  end
end
