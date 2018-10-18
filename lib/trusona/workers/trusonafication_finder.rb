# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Finds Trusonafications
    class TrusonaficationFinder
      def initialize(service: nil)
        @service = service || Trusona::Services::TrusonaficationService.new
      end

      def find(trusonafication_id)
        if trusonafication_id.nil? || trusonafication_id.empty?
          raise(
            Trusona::InvalidResourceError,
            'Trusonafication Id cannot be empty or nil'
          )
        end

        resource = Trusona::Resources::Trusonafication.new(
          id: trusonafication_id
        )
        @service.get(resource)
      end
    end
  end
end