# frozen_string_literal: true

module Trusona
  module Services
    ##
    # A service to interact with the Trusonafications resource
    # in the Trusona REST API
    class TrusonaficationService < BaseService
      def initialize(client: Trusona::Api::HTTPClient.new,
                     mapper: Trusona::Mappers::TrusonaficationMapper.new)
        super
        @resource_path = '/api/v2/trusonafications'
      end
    end
  end
end
