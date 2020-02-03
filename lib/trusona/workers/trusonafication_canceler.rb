# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Cancel a Trusonafication
    class TrusonaficationCanceler
      def initialize(service: nil)
        @service = service || Trusona::Services::TrusonaficationService.new
      end

      def cancel(trusonafication_id)
        if trusonafication_id.nil? || trusonafication_id.strip.empty?
          raise(
            Trusona::InvalidResourceError,
            'Trusonafication Id cannot be empty or nil'
          )
        end

        resource = Trusona::Resources::Trusonafication.new(
          id: trusonafication_id
        )
        @service.delete(resource)
      end
    end
  end
end
