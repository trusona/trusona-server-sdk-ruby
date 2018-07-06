# frozen_string_literal: true

module Trusona
  #
  ## Makes it easy to interface with the User and Accounts APIs
  class UserAccounts
    def self.find_by(opts = {})
      raise ArgumentError unless
        opts[:trusona_id] ||
        opts[:email] ||
        opts['trusona_id'] ||
        opts['email']

      Trusona::Workers::UserAccountFinder.new.find(opts)
    end
  end
end
