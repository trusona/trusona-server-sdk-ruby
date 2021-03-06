# frozen_string_literal: true

module Trusona
  module Mappers
    ## A Pair Trucode Mapper
    class PairedTruCodeMapper < BaseMapper
      def resource
        Trusona::Resources::PairedTruCode
      end
    end
  end
end
