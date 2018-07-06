# frozen_string_literal: true

module Trusona
  module Services
    ##
    # A service to interact with the Device resource in the Trusona REST API
    class DevicesService < BaseService
      def initialize(client: Trusona::Api::HTTPClient.new,
                     mapper: Trusona::Mappers::DeviceMapper.new)
        super
        @resource_path = '/api/v2/devices'
      end
    end
  end
end
