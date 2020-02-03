# frozen_string_literal: true

module Trusona
  module Workers
    #
    ## Creates Trusonafications
    class TrusonaficationCreator
      DEFAULT_TIMEOUT = 30

      def initialize(service: nil)
        @service = service || Trusona::Services::TrusonaficationService.new
      end

      def create(params: {}, timeout: nil, &block)
        raise ArgumentError, 'Missing or empty params hash' if
          params.nil? || params.empty?

        resource = Trusona::Resources::Trusonafication.new(params)
        trusonafication = @service.create(resource)
        return trusonafication unless block_given?

        handle_block(trusonafication, @service, timeout, block)
      end

      private

      # rubocop:disable Metrics/MethodLength

      def handle_block(trusonafication, service, timeout, block)
        timeout ||= DEFAULT_TIMEOUT

        future = Time.now.to_i + timeout
        while Time.now.to_i < future
          t = service.get(trusonafication)
          if t.status == trusonafication.status
            sleep(1)
          else
            block.yield(t)
            break
          end
        end
      end

      # rubocop:enable Metrics/MethodLength
    end
  end
end
