# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Handles finding Devices
    class DeviceFinder
      def initialize(service: Trusona::Services::DevicesService.new)
        @service = service
      end

      def find(id = nil)
        raise(ArgumentError, 'A device identifier is required.') unless id

        @service.get(Trusona::Resources::Device.new(id: id))
      end
    end
  end
end
