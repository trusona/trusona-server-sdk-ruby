# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## A default mapper that does nothing
    class NilMapper
      def map(_json, _resource); end
    end
  end
end
