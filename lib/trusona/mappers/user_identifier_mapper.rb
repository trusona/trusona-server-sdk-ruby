# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## A Mapper for UserIdentifiers
    class UserIdentifierMapper < BaseMapper
      def resource
        Trusona::Resources::UserIdentifier
      end
    end
  end
end
