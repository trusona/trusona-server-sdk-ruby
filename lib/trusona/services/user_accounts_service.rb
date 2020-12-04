# frozen_string_literal: true

module Trusona
  module Services
    #
    ## User Accounts Service
    class UserAccountsService < BaseService
      def initialize(client: nil, mapper: nil)
        @client = client || Trusona::Api::HTTPClient.new(
          Trusona.config.api_host
        )
        super()
        @mapper = mapper || Trusona::Mappers::UserAccountMapper.new
        @resource_path = '/internal/v1/users'
      end
    end
  end
end
