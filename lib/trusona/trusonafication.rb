# frozen_string_literal: true

module Trusona
  ##
  # Defines a nice public api for interacting with Trusonafications
  class Trusonafication
    extend Trusona::Helpers::KeyNormalizer

    ##
    # Finds existing Trusonafications using their ID
    #
    # @param trusonafication_id [String] the ID of an existing Trusonafication
    # @return [Trusona::Resources::Trusonafication] The found Trusonafication
    # @raise [Trusona::InvalidRecordIdentifier] if the +trusonafication_id+ is
    #   empty or nil.
    # @raise [Trusona::ResourceNotFoundError] if the resource does not exist
    #   in the Trusona API
    # @raise (see .create)
    #
    # @example
    #   Trusona::Trusonafication.find('602CB166-A6FC-4EBE-BE83-82E54CF5D161')
    #
    def self.find(trusonafication_id)
      if trusonafication_id.nil? || trusonafication_id.empty?
        raise Trusona::InvalidRecordIdentifier, 'Trusonafication ID is missing'
      end

      Trusona::Workers::TrusonaficationFinder.new.find(trusonafication_id)
    end

    ##
    # Cancels existing IN_PROGRESS Trusonafications using their ID. Once
    # canceled the trusonafication can no longer be acted upon.
    #
    # @param trusonafication_id [String] the ID of an existing Trusonafication
    # @raise [Trusona::InvalidRecordIdentifier] if the +trusonafication_id+ is
    #   empty or nil.
    # @raise [Trusona::ResourceNotFoundError] if the resource does not exist
    #   in the Trusona API
    # @raise [Trusona::UnprocessableEntityError] if the resource could not be
    #   cancel because it was not IN_PROGRESS
    #
    # @example
    #   Trusona::Trusonafication.cancel('756c1034-2159-4cf9-bd48-662a60a7afff')
    #
    def self.cancel(trusonafication_id)
      if trusonafication_id.nil? || trusonafication_id.strip.empty?
        raise Trusona::InvalidRecordIdentifier, 'Trusonafication ID is missing'
      end

      Trusona::Workers::TrusonaficationCanceler.new.cancel(trusonafication_id)
    end

    ##
    # Creates a Trusonafication using the supplied options
    #
    # @param [Hash] params A list of options for creating the Trusonafication
    # @option params [String] :action The action you want the user to take
    #   (e.g. 'login', 'verify')
    # @option params [String] :resource The resource to which the user is
    #   performing the action (e.g. 'website', 'account')
    # @option params [String] :device_identifier The device identifier,
    #  retrieved from the mobile SDK, of the device to which this
    #  Trusonafication will be sent.
    # @option params [String] :user_identifier The user identifier,
    #  previously registered with Trusona, of the user to which this
    #  Trusonafication will be sent.
    # @option params [String] :email The user email address,
    #  previously registered with Trusona, of the user to which this
    #  Trusonafication will be sent.
    # @option params [String] :trucode_id The TruCode ID that has either been
    #  scanned or will be scanned using the mobile SDK that will be used to
    #  determine which device to send the Trusonafication to.
    # @option params [Boolean] :user_presence (true) Should the user be required
    #  to demonstrate presence (e.g. via Biometric) when accepting this
    #  Trusonafication?
    # @option params [Boolean] :prompt (true) Should the user be prompted to
    #  Accept or Reject this Trusonafication?
    # @option params [String] :expires_at ('90 seconds') The ISO-8601 UTC
    #  timestamp of the Trusonafication's expiration.
    # @option params [Hash] :custom_fields Optional data to be associated with
    #  this Trusonafication and can be used to constomize any UX elements. Total
    #  size of data is limited to 1MB.
    # @option params [String] :callback_url A HTTPS URL to POST to call when the
    #  trusonafication has been completed (accepted, rejected, or expired).
    #
    #  NOTE: The URL should include a randomized segment so it cannot be guessed
    #  and abused by third-parties e.g. https://your.domain.com/completed_authentications/f8abe61d-4e51-493f-97b1-464c157624f2.
    #
    # @param timeout [Int] (30) The max amount of time, in seconds, to wait
    #  for a response from the Trusona API when polling for a Trusonafication
    #  result
    # @yield [Trusona::Resources::Trusonafication] Yields the completed
    #  Trusonafication to the block
    # @raise [Trusona::InvalidResourceError] if the resource is not +valid?+
    # @see Trusona::Resources::BaseResource#valid?
    # @raise [Trusona::BadRequestError] if the request is improperly formatted
    # @raise [Trusona::UnauthorizedRequestError] if the request is unauthorized.
    #  Typically the result of invalid or revoked Trusona SDK keys.
    # @raise [Trusona::ApiError] if the Trusona API is experiencing problems.
    #
    def self.create(params: {}, timeout: nil, &)
      normal = normalize_keys(params)

      raise ArgumentError, 'Missing user identifier' unless
        identifier_present?(normal)

      raise ArgumentError, 'Missing action and resource' unless
        normal[:action] && normal[:resource]

      Trusona::Workers::TrusonaficationCreator.new.create(
        params: normal,
        timeout:,
        &
      )
    end

    def self.identifier_present?(normalized_params)
      normalized_params[:user_identifier] ||
        normalized_params[:device_identifier] ||
        normalized_params[:trucode_id] ||
        normalized_params[:trusona_id] ||
        normalized_params[:email]
    end
  end

  ##
  # Creates Essential level Trusonafications. Syntactic sugar on top of
  # {Trusona::Trusonafication}.
  #
  # @example
  #   Trusona::EssentialTrusonafication.create(params: {
  #     action: 'login',
  #     resource: 'Acme Bank',
  #     device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
  #   })
  #
  # @see Trusona::Trusonafication.create
  # @see Trusona::Trusonafication.find
  #
  class EssentialTrusonafication < Trusonafication
    def self.create(params: {}, timeout: nil, &block)
      level = params[:user_presence] == false ? 1 : 2
      super(params: params.merge!(level:), timeout:, &block)
    end
  end

  ##
  # Creates Executive level Trusonafications. Syntactic sugar on top of
  # {Trusona::Trusonafication}.
  #
  # @example
  #   Trusona::ExecutiveLevelTrusonafication.create(params: {
  #     action: 'login',
  #     resource: 'Acme Bank',
  #     device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
  #   })
  #
  # @see Trusona::Trusonafication.create
  # @see Trusona::Trusonafication.find
  #
  class ExecutiveTrusonafication < Trusonafication
    def self.create(params: {}, timeout: nil, &block)
      super(params: params.merge!(level: 3), timeout:, &block)
    end
  end
end
