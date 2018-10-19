# frozen_string_literal: true

module Trusona
  ##
  # Manages the creation of device and user bindings
  class DeviceUserBinding
    ##
    # Binds a device identifier and user identifier together in the Trusona API
    #
    # @param [String] user The user identifier that uniquely identifies the
    #   user in the Relying Party system.
    # @param [String] device The device identifier as retrieved by the Trusona
    #  mobile SDK.
    # @return [Trusona::Resources::DeviceUserBinding] The created device and
    #  user binding record.
    #
    # @see Trusona::Resources::DeviceUserBinding
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
    #   binding = Trusona::DeviceUserBinding.create(
    #     user: '83452353-4F7B-4CA2-BBCD-57ACE7279EA0',
    #     device: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
    #   )
    #
    def self.create(user: nil, device: nil)
      raise ArgumentError, 'User is missing' if user.nil? || user.empty?
      raise ArgumentError, 'Device is missing' if device.nil? || device.empty?

      Trusona::Workers::DeviceUserBindingCreator.new.create(
        user: user, device: device
      )
    end

    ##
    # Activates an existing device and user binding record
    #
    # @param id [String] The ID of the {Trusona::Resources::DeviceUserBinding}
    #   to be activated
    # @raise (see .create)
    # @return [Trusona::Resources::DeviceUserBindingActivation]
    #

    def self.activate(id: nil)
      raise ArgumentError if id.nil? || id.empty?

      Trusona::Workers::DeviceUserBindingActivator.new.activate(id: id)
    end
  end
end
