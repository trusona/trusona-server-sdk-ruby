# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## A Device User Binding Activation
    class DeviceUserBindingActivation < BaseResource
      include Trusona::Resources::Validators
      include Trusona::Helpers::KeyNormalizer
      attr_reader :id, :active

      def initialize(params = {})
        super(params)

        normalized_params = normalize_keys(params)
        @id = normalized_params[:id]
        @active = normalized_params[:active]

        @params = normalized_params
        raise Trusona::InvalidResourceError unless validate
      end

      def validate
        return false unless @id

        true
      end
    end
  end
end
