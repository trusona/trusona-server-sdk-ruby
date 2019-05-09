# frozen_string_literal: true

module Trusona
  module Services
    class PairedTruCodeService < BaseService
      def initialize(client: Trusona::Api::HTTPClient.new)
        super(client: client)
        @resource_path = '/api/v2/paired_trucodes'
      end
    end
  end
end
