# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Finds TruCodes
    class TruCodeFinder
      def initialize(service: Trusona::Services::TruCodesService.new)
        @service = service
      end

      def find(id)
        raise ArgumentError, 'Missing TruCode Id' unless id

        resource = Trusona::Resources::BaseResource.new(id: id)
        @service.get(resource)
      end
    end
  end
end
