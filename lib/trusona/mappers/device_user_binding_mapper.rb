# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## Maps Device User Binding Responses
    class DeviceUserBindingMapper < BaseMapper
      def resource
        Trusona::Resources::DeviceUserBinding
      end
    end
  end
end
