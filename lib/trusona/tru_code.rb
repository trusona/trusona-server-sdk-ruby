# frozen_string_literal: true

module Trusona
  ##
  # A scannable, pairable TruCode to assist magic logins
  class TruCode
    ##
    # Finds a TruCode using its ID
    #
    # @param id [String] The id of the TruCode we're looking for
    # @return [Trusona::Resources::TruCode] The found TruCode
    # @raise [Trusona::ResourceNotFoundError] if the TruCode cannot be found
    # @raise [Trusona::BadRequestError] if the request is improperly formatted
    # @raise [Trusona::UnauthorizedRequestError] if the request is unauthorized.
    #  Typically the result of invalid or revoked Trusona SDK keys.
    # @raise [Trusona::ApiError] if the Trusona API is experiencing problems.
    # @raise [ArgumentError] if the TruCode id is missing
    #
    def self.find(id)
      Trusona::Workers::TruCodeFinder.new.find(id)
    end

    ##
    # Finds a TruCode using its ID
    #
    # @param id [String] The id of the TruCode we're looking for
    # @return [Trusona::Resources::TruCode] The found TruCode
    # @raise (see .find)
    #
    def self.status(id)
      Trusona::Workers::TruCodeStatus.new.status(id)
    end

    def self.create(code)
      Trusona::Workers::TruCodeCreator.new.create(code)
    end
  end
end
