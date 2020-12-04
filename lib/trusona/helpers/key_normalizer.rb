# frozen_string_literal: true

module Trusona
  module Helpers
    ##
    # Noramlizes keys by turning all key values into symbols
    module KeyNormalizer
      def normalize_keys(hash)
        hash.transform_keys(&:to_sym)
      end
    end
  end
end
