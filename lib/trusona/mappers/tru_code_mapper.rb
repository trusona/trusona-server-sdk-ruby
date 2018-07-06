# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## A Mapper for TruCodes
    class TruCodeMapper < BaseMapper
      def resource
        Trusona::Resources::TruCode
      end
    end
  end
end
