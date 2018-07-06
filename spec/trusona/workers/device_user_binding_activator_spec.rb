# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::DeviceUserBindingActivator do
  before do
    @pass_through_service = double(update: true)
  end

  describe 'creating a Device User Binding Activator' do
    it 'optionally accepts a service' do
      Trusona::Workers::DeviceUserBindingActivator.new(
        service: @pass_through_service
      )
    end

    it 'uses a default service' do
      expect(Trusona::Services::DeviceUserBindingsService).to receive(:new)
      Trusona::Workers::DeviceUserBindingActivator.new
    end
  end

  describe 'activating an existing device and user binding record' do
    it 'requires a device user binding record id' do
      sut = Trusona::Workers::DeviceUserBindingActivator.new(
        service: @pass_through_service
      )
      expect { sut.activate(id: nil) }.to(raise_error(ArgumentError))
      expect { sut.activate(id: '') }.to(raise_error(ArgumentError))
      sut.activate(id: 'some-id')
    end

    it 'tells the service to update the record' do
      stub = double(
        Trusona::Resources::DeviceUserBindingActivation,
        id: '1234-abcd',
        active: true
      )

      allow(Trusona::Resources::DeviceUserBindingActivation).to(
        receive(:new)
      ).and_return(stub)

      spy = double
      sut = Trusona::Workers::DeviceUserBindingActivator.new(service: spy)

      expect(spy).to receive(:update).with(stub)

      sut.activate(id: 'some-id')
    end
  end
end
