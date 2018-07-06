# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Handles finding Identity Documents
    class IdentityDocumentFinder
      def initialize(service: nil)
        @service = service || Trusona::Services::IdentityDocumentsService.new
      end

      def find_all(user_identifier = nil)
        raise(ArgumentError, 'A user identifier is required.') unless
          user_identifier

        @service.index(user_identifier)
      end

      def find(id = nil)
        raise(ArgumentError, 'An Identity Document id is required.') unless id
        @service.get(Trusona::Resources::IdentityDocument.new(id: id))
      end
    end
  end
end
