# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## Basic validators for working with Resources
    module Validators
      def present?(item)
        return false if item.nil? || item.to_s.empty?

        true
      end

      def valid?
        validate
      end

      def validate
        true
      end
    end
  end
end
