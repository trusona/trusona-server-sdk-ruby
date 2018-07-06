# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## A worker that creates TruCodes
    class TruCodeCreator
      def initialize(service = nil)
        @service = service || Trusona::Services::TruCodesService.new
      end

      def create(code)
        @service.create(code)
      end
    end
  end
end
