# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## Maps Identity Document Responses
    class IdentityDocumentMapper < BaseMapper
      def resource
        Trusona::Resources::IdentityDocument
      end

      def custom_mappings
        { hash: :document_hash }
      end
    end
  end
end
