# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Finds user identifers
    class UserIdentifierFinder
      def initialize(service: nil)
        @service = service || Trusona::Services::UserIdentifiersService.new
      end

      def find(opts)
        raise ArgumentError, 'Missing user identifier' unless
          contains_required_arguments(opts)

        @service.get(build_resource(opts))
      end

      private

      def contains_required_arguments(opts)
        opts[:identifier] || opts['identifier']
      end

      def build_resource(options)
        Trusona::Resources::UserIdentifier.new(options)
      end
    end
  end
end
