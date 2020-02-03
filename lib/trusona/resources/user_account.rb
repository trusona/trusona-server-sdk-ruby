# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## a potentially scanned and or paired TruCode
    class UserAccount < BaseResource
      module Status
        ACTIVE   = 'active'
        INACTIVE = 'inactive'
        UNKNOWN  = 'unknown'
      end

      module Level
        ENTRY     = 'entry'
        ESSENTIAL = 'essential'
        EXECUTIVE = 'executive'
      end

      include Trusona::Resources::Validators
      include Trusona::Helpers::KeyNormalizer

      attr_reader :id, :trusona_id, :email, :status, :first_name, :last_name,
                  :nickname, :handle, :emails, :max_level

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def initialize(params = {})
        params_with_symbol_keys = normalize_keys(params)
        @trusona_id = params_with_symbol_keys[:trusona_id]
        @id         = @trusona_id
        @email      = params_with_symbol_keys[:email]
        @status     = determine_status(params_with_symbol_keys[:status])
        @first_name = params_with_symbol_keys[:first_name]
        @last_name  = params_with_symbol_keys[:last_name]
        @nickname   = params_with_symbol_keys[:nickname]
        @handle     = params_with_symbol_keys[:handle]
        @emails     = parse_emails(params_with_symbol_keys[:emails])
        @max_level  = parse_max_level(params_with_symbol_keys[:metadata])

        @params = params_with_symbol_keys
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def to_json(*_args)
        JSON(to_h)
      end

      private

      def determine_status(status)
        return Status::INACTIVE if status == 'inactive'
        return Status::ACTIVE if status == 'active'

        Status::UNKNOWN
      end

      def parse_emails(emails)
        return [] if emails.nil? || emails.empty?

        emails.map { |e| UserAccountEmail.new(e) }
      end

      def parse_max_level(metadata)
        return Level::ENTRY unless metadata

        level = metadata['max_level'] || metadata[:max_level]

        return Level::ESSENTIAL if level == 'essential'
        return Level::EXECUTIVE if level == 'executive'

        Level::ENTRY
      end

      #
      ## An email associated with a user account
      class UserAccountEmail
        attr_reader :email, :id, :verified
        def initialize(email = {})
          @email    = email[:email] || email['email']
          @id       = email[:id] || email['id']
          @verified = email[:verified] || email['verified'] || false
        end
      end
    end
  end
end
