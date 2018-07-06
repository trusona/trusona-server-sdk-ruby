# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Creates user identifers
    class UserIdentifierCreator
      def initialize(service: nil)
        @service = service || Trusona::Services::UserIdentifiersService.new
      end

      def create(identifier)
        @service.create(identifier)
      end
    end
  end
end
