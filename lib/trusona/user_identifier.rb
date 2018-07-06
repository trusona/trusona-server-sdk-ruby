# frozen_string_literal: true

module Trusona
  #
  ## Makes it easy to interface with the User Identifier APIs
  class UserIdentifier
    def self.find_by(opts = {})
      Trusona::Workers::UserIdentifierFinder.new.find(opts)
    end

    def self.create(identifier)
      Trusona::Workers::UserIdentifierCreator.new.create(identifier)
    end
  end
end
