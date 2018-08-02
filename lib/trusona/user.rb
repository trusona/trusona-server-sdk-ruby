# frozen_string_literal: true

module Trusona
  #
  ## Makes it easy to interface with the User APIs
  class User
    def self.deactivate(user_identifier: nil)
      Trusona::Workers::UserDeactivator.new.deactivate(user_identifier)
    end
  end
end
