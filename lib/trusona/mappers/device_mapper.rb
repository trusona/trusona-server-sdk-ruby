# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## Maps Device Responses
    class DeviceMapper < BaseMapper
      def resource
        Trusona::Resources::Device
      end
    end
  end
end
