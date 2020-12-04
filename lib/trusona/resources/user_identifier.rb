# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## a relying party specific user identifier
    class UserIdentifier < BaseResource
      include Trusona::Resources::Validators
      attr_reader :identifier, :trusona_id

      def initialize(params = {})
        super(params)
        @params     = params
        @identifier = params[:identifier]
        @trusona_id = params[:trusona_id]
        @id         = @identifier
      end

      def to_h
        @params
      end

      def to_json(*_args)
        JSON(to_h)
      end

      def valid?
        validate
      end

      def validate
        attributes_present && attributes_filled
      end

      private

      def attributes_present
        return false unless @params.key?(:identifier)
        return false unless @params.key?(:trusona_id)

        true
      end

      def attributes_filled
        return false if @params.fetch(:identifier).empty?
        return false if @params.fetch(:trusona_id).empty?

        true
      end
    end
  end
end
