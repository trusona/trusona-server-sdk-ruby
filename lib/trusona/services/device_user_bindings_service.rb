# frozen_string_literal: true

module Trusona
  module Services
    #
    ## Device User Bindings Service
    class DeviceUserBindingsService < BaseService
      def initialize(
        client: Trusona::Api::HTTPClient.new(Trusona.config.api_host),
        mapper: Trusona::Mappers::DeviceUserBindingMapper.new
      )
        @client = client
        @mapper = mapper
        @resource_path = '/api/v2/user_devices'
      end
    end
  end
end
