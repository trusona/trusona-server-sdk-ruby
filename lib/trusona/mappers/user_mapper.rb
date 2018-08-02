# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## Maps User Responses
    class UserMapper < BaseMapper
      def resource
        Trusona::Resources::User
      end
    end
  end
end
