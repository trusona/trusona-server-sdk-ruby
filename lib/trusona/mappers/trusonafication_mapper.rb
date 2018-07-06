# frozen_string_literal: true

module Trusona
  module Mappers
    ##
    # A mapper for Trusonafication
    class TrusonaficationMapper < BaseMapper
      def resource
        Trusona::Resources::Trusonafication
      end

      def custom_mappings
        {
          desired_level: :level
        }
      end
    end
  end
end
