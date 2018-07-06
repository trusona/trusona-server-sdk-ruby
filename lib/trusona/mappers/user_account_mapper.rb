# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## A Mapper for User Accounts
    class UserAccountMapper < BaseMapper
      def resource
        Trusona::Resources::UserAccount
      end
    end
  end
end
