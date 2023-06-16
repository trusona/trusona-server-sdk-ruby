# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Activates Device and User binding records
    class DeviceUserBindingActivator
      def initialize(service: nil)
        @service = service || Trusona::Services::DeviceUserBindingsService.new
      end

      def activate(id: nil)
        raise ArgumentError, 'Missing Device+User Binding Id' if
          id.nil? || id.empty?

        resource = Trusona::Resources::DeviceUserBindingActivation.new(
          id:,
          active: true
        )

        @service.update(resource)
      end
    end
  end
end
