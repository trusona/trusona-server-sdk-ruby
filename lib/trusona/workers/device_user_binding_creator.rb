# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Handles creating device and user bindings
    class DeviceUserBindingCreator
      def initialize(service: nil)
        @service = service || Trusona::Services::DeviceUserBindingsService.new
      end

      def create(user: nil, device: nil)
        raise ArgumentError, 'Missing user identifier' if
          user.nil? || user.empty?
        raise ArgumentError, 'Missing device identifier' if
          device.nil? || device.empty?

        resource = Trusona::Resources::DeviceUserBinding.new(
          user_identifier: user,
          device_identifier: device
        )
        @service.create(resource)
      end
    end
  end
end
