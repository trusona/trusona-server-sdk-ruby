# frozen_string_literal: true

module Trusona
  ##
  # Helpful for finding Identity Documents given a user identifier or
  # Identity Document identifier
  class IdentityDocument
    ##
    # Finds all of the identity documents associated with the user identifier
    #
    # @param [String] user_identifier The user identifier associated with the
    #   requested identity documents.
    # @return [Array<Trusona::Resources::IdentityDocument>] A collection of
    #   identity
    #   documents.
    # @raise ArgumentError if the user_identifier is nil
    #
    # @raise [Trusona::InvalidResourceError] if the resource is not +valid?+
    # @see Trusona::Resources::BaseResource#valid?
    # @raise [Trusona::BadRequestError] if the request is improperly formatted
    # @raise [Trusona::UnauthorizedRequestError] if the request is unauthorized.
    #  Typically the result of invalid or revoked Trusona SDK keys.
    # @raise [Trusona::ApiError] if the Trusona API is experiencing problems.
    #
    # @example
    #
    #   Trusona::IdentityDocument.find_all('user-1234')
    #

    def self.all(user_identifier: nil)
      # rubocop:disable Layout/LineLength
      raise ArgumentError, 'A user identifier is required.' unless user_identifier

      # rubocop:enable Layout/LineLength

      Trusona::Workers::IdentityDocumentFinder.new.find_all(user_identifier)
    end

    ##
    # Finds the specified identity document
    #
    # @param [String] id The id of the Identity Document
    # @return [Trusona::Resources::IdentityDocument] the Identity Document
    # @raise ArgumentError if the user_identifier is nil
    #
    # @raise [Trusona::InvalidResourceError] if the resource is not +valid?+
    # @see Trusona::Resources::BaseResource#valid?
    # @raise [Trusona::BadRequestError] if the request is improperly formatted
    # @raise [Trusona::UnauthorizedRequestError] if the request is unauthorized.
    #  Typically the result of invalid or revoked Trusona SDK keys.
    # @raise [Trusona::ApiError] if the Trusona API is experiencing problems.
    #
    # @example
    #
    #   Trusona::IdentityDocument.find('4FDF044D-89FB-4043-947D-A029CF785B5F')
    #
    def self.find(id: nil)
      # rubocop:disable Layout/LineLength
      raise ArgumentError, 'An Identity Document identifier is required.' unless id

      # rubocop:enable Layout/LineLength

      Trusona::Workers::IdentityDocumentFinder.new.find(id)
    end
  end
end
