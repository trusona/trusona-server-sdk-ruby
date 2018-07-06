# frozen_string_literal: true

module Trusona
  ##
  # Helpful for finding Devices to determine if and when they were activated
  class Device
    ##
    # Finds the specified device
    #
    # @param [String] id The identifier of the Device
    # @return [Trusona::Resources::Device] the Device
    # @raise ArgumentError if the identifier is nil
    #
    # @raise [Trusona::InvalidResourceError] if the resource is not +valid?+
    # @see Trusona::Resources::BaseResource#valid?
    # @raise [Trusona::BadRequestError] if the request is improperly formatted
    # @raise [Trusona::UnauthorizedRequestError] if the request is unauthorized.
    #  Typically the result of invalid or revoked Trusona SDK keys.
    # @raise [Trusona::ApiError] if the Trusona API is experiencing problems.
    #
    # @example
    #
    #   Trusona::Device.find(id: 'r1ByVyVKJ7TRgU0RPX0-THMTD_CO3VrCSNqLpJFmhms')
    #
    def self.find(id: nil)
      raise ArgumentError, 'A Device identifier is required.' unless id

      Trusona::Workers::DeviceFinder.new.find(id)
    end
  end
end
