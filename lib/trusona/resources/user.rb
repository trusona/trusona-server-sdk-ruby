# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## A record representing a user in the Trusona API
    class User < BaseResource
      include Trusona::Helpers::KeyNormalizer

      attr_reader :id, :user_identifier

      def initialize(params = {})
        super
        @params = normalize_keys(params)

        @user_identifier = @params[:user_identifier]
        @id              = @user_identifier
      end
    end
  end
end
