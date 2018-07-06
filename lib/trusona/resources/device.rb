# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## A record representing a device in the Trusona API
    class Device < BaseResource
      include Trusona::Helpers::KeyNormalizer
      include Trusona::Helpers::TimeNormalizer

      attr_reader :active, :activated_at

      def initialize(params = {})
        super
        @params = normalize_keys(params)

        @active       = @params[:active]
        @activated_at = normalize_time(@params[:activated_at])
      end
    end
  end
end
