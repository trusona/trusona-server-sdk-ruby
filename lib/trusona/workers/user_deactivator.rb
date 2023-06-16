# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Handles deactivating Users
    class UserDeactivator
      def initialize(service: Trusona::Services::UsersService.new)
        @service = service
      end

      def deactivate(user_identifier)
        raise(ArgumentError, "The user's identifier is required") if user_identifier.nil? || user_identifier.empty?

        user = Trusona::Resources::User.new(user_identifier:)
        @service.delete(user)
      end
    end
  end
end
