# frozen_string_literal: true

require 'httparty'
require 'ostruct'

require 'trusona/helpers/key_normalizer'
require 'trusona/helpers/time_normalizer'

require 'trusona/version'
require 'trusona/errors'
require 'trusona/trusonafication'
require 'trusona/tru_code'
require 'trusona/tru_code_config'
require 'trusona/user_account'
require 'trusona/user_identifier'
require 'trusona/device_user_binding'
require 'trusona/identity_document'
require 'trusona/device'
require 'trusona/user'
require 'trusona/paired_tru_code'

require 'trusona/api/signed_request'
require 'trusona/api/verified_response'
require 'trusona/api/hashed_message'
require 'trusona/api/client'

require 'trusona/workers/tru_code_creator'
require 'trusona/workers/tru_code_finder'
require 'trusona/workers/user_account_finder'
require 'trusona/workers/user_identifier_finder'
require 'trusona/workers/user_identifier_creator'
require 'trusona/workers/device_user_binding_creator'
require 'trusona/workers/device_user_binding_activator'
require 'trusona/workers/trusonafication_creator'
require 'trusona/workers/trusonafication_finder'
require 'trusona/workers/trusonafication_canceler'
require 'trusona/workers/identity_document_finder'
require 'trusona/workers/device_finder'
require 'trusona/workers/user_deactivator'
require 'trusona/workers/paired_tru_code_finder'

require 'trusona/services/base_service'
require 'trusona/services/user_accounts_service'
require 'trusona/services/account_lookups_service'
require 'trusona/services/tru_codes_service'
require 'trusona/services/trusonafication_service'
require 'trusona/services/user_identifiers_service'
require 'trusona/services/device_user_bindings_service'
require 'trusona/services/identity_documents_service'
require 'trusona/services/devices_service'
require 'trusona/services/users_service'
require 'trusona/services/paired_tru_code_service'

require 'trusona/mappers/base_mapper'
require 'trusona/mappers/tru_code_mapper'
require 'trusona/mappers/nil_mapper'
require 'trusona/mappers/trusonafication_mapper'
require 'trusona/mappers/user_account_mapper'
require 'trusona/mappers/user_identifier_mapper'
require 'trusona/mappers/device_user_binding_mapper'
require 'trusona/mappers/identity_document_mapper'
require 'trusona/mappers/device_mapper'
require 'trusona/mappers/user_mapper'
require 'trusona/mappers/paired_tru_code_mapper'

require 'trusona/resources/validators'
require 'trusona/resources/base_resource'
require 'trusona/resources/trusonafication'
require 'trusona/resources/tru_code'
require 'trusona/resources/user_account'
require 'trusona/resources/user_identifier'
require 'trusona/resources/device_user_binding'
require 'trusona/resources/device_user_binding_activation'
require 'trusona/resources/identity_document'
require 'trusona/resources/device'
require 'trusona/resources/user'
require 'trusona/resources/paired_tru_code'

# Trusona
module Trusona
  #
  ## Organizing HTTP and HMAC related items
  module Api; end

  #
  ## Organizes Resources
  module Resources; end

  #
  ## Organizes Services and related behavior
  module Services; end

  #
  ## Organizes Mappers
  module Mappers; end

  #
  ## Organizes Workers
  module Workers; end

  #
  ## Organizes Helpers
  module Helpers; end

  ##
  # Configures the Trusona SDK with the required parameters by creating and
  # using an instance of +Trusona::Configuration+.
  #
  #   Trusona.config do |c|
  #     c.api_host       = ENV['TRUSONA_API_HOST']
  #     c.secret         = ENV['TRUSONA_SECRET']
  #     c.token          = ENV['TRUSONA_TOKEN']
  #   end
  #
  def self.config
    if block_given?
      @config = Configuration.new
      yield(@config)
    end

    raise Trusona::ConfigurationError unless @config

    @config
  end

  ##
  # Represents Trusona configuration
  #
  # @attr token [String] The JWT token supplied by Trusona for interacting
  #                      with the Trusona API
  #
  # @attr secret [String] The secret supplied by Trusona for interacting with
  #                       the Trusona API
  #
  # @attr_reader api_host [String] The full URL of the Trusona API
  #                                (e.g. +https://api.trusona.net+)
  class Configuration
    attr_accessor :token, :secret
    attr_reader :api_host

    def initialize
      @api_host = 'api.trusona.net'
    end

    ##
    # sets the API host by first ensuring the proper format
    # @param host [String] The full URL of the Trusona API
    def api_host=(host)
      @api_host = URI(host).host || host
    end
  end
end
