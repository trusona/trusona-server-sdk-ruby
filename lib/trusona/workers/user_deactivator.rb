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
        if user_identifier.nil? || user_identifier.empty?
          raise(ArgumentError, "The user's identifier is required")
        end

        user = Trusona::Resources::User.new(user_identifier: user_identifier)
        @service.delete(user)
      end
    end
  end
end
