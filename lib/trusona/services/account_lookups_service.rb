# frozen_string_literal: true

module Trusona
  module Services
    #
    ## User Accounts Service
    class AccountLookupsService < BaseService
      def initialize(client: nil, mapper: nil)
        @client = client || Trusona::Api::HTTPClient.new(
          Trusona.config.api_host
        )
        @mapper = mapper || Trusona::Mappers::UserAccountMapper.new
        @resource_path = '/internal/v1/account_lookups'
      end
    end
  end
end
