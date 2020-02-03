# frozen_string_literal: true

module Trusona
  module Workers
    # Paired trucode finder
    class PairedTruCodeFinder
      def initialize(service: Trusona::Services::PairedTruCodeService.new)
        @service = service
      end

      def find(trucode_id)
        raise 'A TruCode ID is required' unless trucode_id

        @service.get(Trusona::Resources::PairedTruCode.new(id: trucode_id))
      end
    end
  end
end
