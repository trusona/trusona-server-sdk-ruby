# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Finds user accounts
    class UserAccountFinder
      def initialize(user_accounts_service: nil, account_lookups_service: nil)
        @lookups = account_lookups_service ||
                   Trusona::Services::AccountLookupsService.new
        @user_accounts = user_accounts_service ||
                         Trusona::Services::UserAccountsService.new
      end

      def find(opts)
        raise ArgumentError, 'Missing email or trusona id' unless
          contains_required_arguments(opts)

        resource = build_resource(opts)

        return @user_accounts.get(resource) if opts[:trusona_id] || opts['trusona_id']

        @lookups.create(resource) if opts[:email] || opts['email']
      end

      private

      def contains_required_arguments(opts)
        opts[:email] || opts['email'] || opts[:trusona_id] || opts['trusona_id']
      end

      def build_resource(options)
        Trusona::Resources::UserAccount.new(options)
      end
    end
  end
end
