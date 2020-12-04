# frozen_string_literal: true

module Trusona
  module Services
    #
    ## User Identifiers Service
    class UserIdentifiersService < BaseService
      def initialize(client: nil, mapper: nil)
        super(client, mapper)
        @client = client ||
                  Trusona::Api::HTTPClient.new(Trusona.config.api_host)
        @mapper = mapper || Trusona::Mappers::UserIdentifierMapper.new
        @resource_path = '/api/v2/user_identifiers'
      end
    end
  end
end
