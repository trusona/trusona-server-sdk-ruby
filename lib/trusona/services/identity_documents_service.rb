# frozen_string_literal: true

module Trusona
  module Services
    #
    ## Identity Documents Service
    class IdentityDocumentsService < BaseService
      def initialize(
        client: Trusona::Api::HTTPClient.new(Trusona.config.api_host),
        mapper: Trusona::Mappers::IdentityDocumentMapper.new
      )
        @client = client
        @mapper = mapper
        @resource_path = '/api/v2/identity_documents'
      end

      def index(user_identifier = nil)
        modified_collection_path =
          "#{collection_path}?user_identifier=#{user_identifier}"

        handle(@client.get(modified_collection_path))
      end

      private

      def not_found
        nil
      end
    end
  end
end
