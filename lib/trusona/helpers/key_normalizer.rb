# frozen_string_literal: true

module Trusona
  module Helpers
    ##
    # Noramlizes keys by turning all key values into symbols
    module KeyNormalizer
      def normalize_keys(hash)
        hash.each_with_object({}) do |(k, v), memo|
          memo[k.to_sym] = v
        end
      end
    end
  end
end
