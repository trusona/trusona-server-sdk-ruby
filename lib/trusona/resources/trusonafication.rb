# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Trusona
  module Resources
    ##
    # Represents a Trusonafication resource
    class Trusonafication < BaseResource
      include Trusona::Helpers::KeyNormalizer
      include Trusona::Helpers::TimeNormalizer

      attr_accessor :device_identifier, :user_identifier, :trucode_id,
                    :resource, :action, :level, :id, :email,
                    :accepted_level, :trusona_id, :expires_at,
                    :user_presence, :prompt, :custom_fields, :callback_url

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def initialize(params = {})
        super(params)

        @params = normalize_keys(params)
        return if @params.nil?

        self.accepted_level    = determine_accepted_level(@params)
        self.action            = @params[:action]
        self.device_identifier = @params[:device_identifier]
        self.user_identifier   = @params[:user_identifier]
        self.trucode_id        = @params[:trucode_id]
        self.email             = @params[:email]
        self.expires_at        = normalize_time(@params[:expires_at])
        self.id                = @params[:id]
        self.level             = @params[:level]
        self.resource          = @params[:resource]
        self.trusona_id        = @params[:trusona_id]
        self.prompt            = defaulting_to(true, @params[:prompt])
        self.user_presence     = defaulting_to(true, @params[:user_presence])
        self.custom_fields     = @params[:custom_fields]
        self.callback_url      = @params[:callback_url]

        @status = @params[:status]
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def to_h
        @params
      end

      # rubocop:disable Metrics/MethodLength
      def to_json(*_args)
        JSON(
          device_identifier: device_identifier,
          user_identifier: user_identifier,
          trucode_id: trucode_id,
          trusona_id: trusona_id,
          email: email,
          resource: resource,
          action: action,
          desired_level: level,
          id: id,
          status: @status,
          prompt: prompt,
          user_presence: user_presence,
          custom_fields: custom_fields,
          expires_at: expires_at&.iso8601,
          callback_url: callback_url
        )
      end
      # rubocop:enable Metrics/MethodLength

      def accepted?
        return true if status == :accepted
        return true if status == :accepted_at_higher_level

        false
      end

      def rejected?
        !accepted?
      end

      def valid?
        attributes_present && attributes_filled
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def status
        case @status
        when 'INVALID_TRUSONA_ID'
          :invalid_trusona_id
        when 'IN_PROGRESS'
          :in_progress
        when 'REJECTED'
          :rejected
        when 'ACCEPTED'
          :accepted
        when 'INVALID_EMAIL'
          :invalid_email
        when 'ACCEPTED_AT_LOWER_LEVEL'
          :accepted_at_lower_level
        when 'ACCEPTED_AT_HIGHER_LEVEL'
          :accepted_at_higher_level
        when 'EXPIRED'
          :expired
        else
          :invalid
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

      private

      def defaulting_to(value, param)
        return value if param.nil?
        return value if param.respond_to?(:empty?) && param.empty?

        param
      end

      def determine_accepted_level(params)
        params[:result][:accepted_level] unless params[:result].nil?
      end

      def attributes_present
        return false if identifier.nil?
        return false if resource.nil?
        return false if action.nil?
        return false if level.nil?

        true
      end

      def attributes_filled
        return false if identifier.empty?
        return false if resource.empty?
        return false if action.empty?

        true
      end

      def identifier
        device_identifier || user_identifier || trucode_id || trusona_id || email
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
