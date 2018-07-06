# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::DeviceUserBindingCreator do
  describe 'creating the worker' do
    it 'optionally accepts a service' do
      Trusona::Workers::DeviceUserBindingCreator.new(service: double)
    end

    it 'uses a default service' do
      Trusona::Workers::DeviceUserBindingCreator.new
    end
  end

  describe 'creating bindings' do
    it 'requires a user identifier' do
      sut = Trusona::Workers::DeviceUserBindingCreator.new(service: double)
      expect { sut.create(user: nil, device: 'device') }.to(
        raise_error(ArgumentError)
      )
      expect { sut.create(user: '', device: 'device') }.to(
        raise_error(ArgumentError)
      )
    end

    it 'requires a device identifier' do
      sut = Trusona::Workers::DeviceUserBindingCreator.new(service: double)
      expect { sut.create(user: 'user', device: '') }.to(
        raise_error(ArgumentError)
      )
      expect { sut.create(user: 'user', device: nil) }.to(
        raise_error(ArgumentError)
      )
    end

    it 'tells the service to create the binding' do
      spy = double
      sut = Trusona::Workers::DeviceUserBindingCreator.new(service: spy)

      expect(spy).to receive(:create)

      sut.create(user: 'user', device: 'device')
    end
  end
end
