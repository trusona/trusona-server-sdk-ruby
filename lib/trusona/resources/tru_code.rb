# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## A TruCode used for magic logins
    class TruCode < BaseResource
      include Trusona::Resources::Validators
      include Trusona::Helpers::KeyNormalizer

      attr_reader :relying_party_id, :payload, :id

      def initialize(params = {})
        normalized_params = normalize_keys(params)
        @id = normalized_params[:id]
        @payload = normalized_params[:payload]
        @relying_party_id = normalized_params[:relying_party_id] ||
                            Trusona::TruCodeConfig.new.relying_party_id
        raise ArgumentError unless validate
      end

      def to_json
        JSON(to_h)
      end

      def to_h
        {
          id: @id,
          relying_party_id: @relying_party_id,
          payload: @payload
        }
      end

      private

      def validate
        return false unless present?(@relying_party_id)
        true
      end
    end
  end
end
