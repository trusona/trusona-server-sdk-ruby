# frozen_string_literal: true

module Trusona
  module Resources
    class PairedTruCode < BaseResource
      attr_reader :identifier

      def initialize(params = {})
        super(params)
        @identifier = params[:identifier]
      end
    end
  end
end
