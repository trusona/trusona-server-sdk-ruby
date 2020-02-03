# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## A record representing a device and user binding in the Trusona API
    class DeviceUserBinding < BaseResource
      include Trusona::Resources::Validators
      include Trusona::Helpers::KeyNormalizer
      attr_reader :user_identifier, :device_identifier, :active, :id

      def initialize(params = {})
        normalized_params  = normalize_keys(params)
        @user_identifier   = normalized_params[:user_identifier]
        @device_identifier = normalized_params[:device_identifier]
        @active            = normalized_params[:active]
        @id                = normalized_params[:id]

        @params = normalized_params
        raise Trusona::InvalidResourceError unless validate
      end

      def validate
        return false unless @user_identifier
        return false unless @device_identifier

        true
      end
    end
  end
end
