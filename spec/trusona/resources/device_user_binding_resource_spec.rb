# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::DeviceUserBinding do
  describe 'as json' do
    it 'should use the available parameters' do
      params = { device_identifier: 'device', user_identifier: 'user' }

      sut = Trusona::Resources::DeviceUserBinding.new(params)
      expect(sut.to_json).to(
        eq(JSON(device_identifier: 'device', user_identifier: 'user'))
      )
    end
  end
  describe 'creating a new device user binding' do
    it 'requires a user identifier' do
      params = { device_identifier: 'device', user_identifier: 'user' }
      bad_params = params.merge!(user_identifier: nil)
      expect do
        Trusona::Resources::DeviceUserBinding.new(bad_params)
      end.to(raise_error(Trusona::InvalidResourceError))
    end

    it 'requires a device identifier' do
      params = { device_identifier: 'device', user_identifier: 'user' }
      bad_params = params.merge!(device_identifier: nil)
      expect do
        Trusona::Resources::DeviceUserBinding.new(bad_params)
      end.to(raise_error(Trusona::InvalidResourceError))
    end
  end
end
