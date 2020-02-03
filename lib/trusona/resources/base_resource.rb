# frozen_string_literal: true

module Trusona
  module Resources
    #
    ## A base resource
    class BaseResource
      include Trusona::Resources::Validators
      attr_reader :id

      def initialize(params = {})
        @params = params
        @id = params[:id] || params['id']
      end

      def to_h
        @params
      end

      def to_json(*_args)
        JSON(to_h)
      end

      def valid?
        true
      end
    end
  end
end
