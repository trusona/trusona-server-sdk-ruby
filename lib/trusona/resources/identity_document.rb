# frozen_string_literal: true

module Trusona
  module Resources
    ##
    # A record representing an identity document in the Trusona API
    class IdentityDocument < BaseResource
      include Trusona::Resources::Validators
      include Trusona::Helpers::KeyNormalizer

      attr_accessor :document_hash, :id, :type, :verification_status,
                    :user_identifier

      def initialize(params)
        super(params)

        normalized = normalize_keys(params)
        @params = normalized
        @document_hash = normalized[:document_hash]
        @id = normalized[:id]
        @type = normalized[:type]
        @verification_status = normalized[:verification_status]
        @user_identifier     = normalized[:user_identifier]
      end

      def to_json(*_args)
        JSON(
          hash: @document_hash,
          id: @id,
          type: @type,
          verification_status: @verification_status,
          user_identifier: @user_identifier
        )
      end
    end
  end
end
