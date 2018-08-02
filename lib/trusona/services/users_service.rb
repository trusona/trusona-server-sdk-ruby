# frozen_string_literal: true

module Trusona
  module Services
    ##
    # A service to interact with the User resource in the Trusona REST API
    class UsersService < BaseService
      def initialize(client: Trusona::Api::HTTPClient.new,
                     mapper: Trusona::Mappers::UserMapper.new)
        super
        @resource_path = '/api/v2/users'
      end
    end
  end
end
