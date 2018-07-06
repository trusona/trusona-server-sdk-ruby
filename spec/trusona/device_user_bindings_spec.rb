# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::DeviceUserBinding do
  describe 'creating device and user bindings' do
    it 'requires a user and device identifier' do
      allow(Trusona::Workers::DeviceUserBindingCreator).to(
        receive(:new)
      ).and_return(double(create: double))
      Trusona::DeviceUserBinding.create(user: 'user', device: 'device')
    end

    it 'tells the worker to create the binding' do
      stub = double(Trusona::Workers::DeviceUserBindingCreator)

      allow(Trusona::Workers::DeviceUserBindingCreator).to(
        receive(:new)
      ).and_return(
        stub
      )

      expect(stub).to receive(:create).with(user: 'user', device: 'device')

      Trusona::DeviceUserBinding.create(user: 'user', device: 'device')
    end

    context 'when the user identifier is empty' do
      it 'an error is raised' do
        expect do
          Trusona::DeviceUserBinding.create(user: '', device: 'device')
        end.to(raise_error(ArgumentError))
      end
    end

    context 'when the device identifier is empty' do
      it 'an error is raised' do
        expect do
          Trusona::DeviceUserBinding.create(user: 'user', device: '')
        end.to(raise_error(ArgumentError))
      end
    end
  end

  describe 'activating a device and user binding' do
    before do
      allow(Trusona::Workers::DeviceUserBindingActivator).to(
        receive(:new)
      ).and_return(double(activate: double))
    end

    it 'requires the id of an existing device and user binding record' do
      expect { Trusona::DeviceUserBinding.activate(id: nil) }.to(
        raise_error(ArgumentError)
      )

      expect { Trusona::DeviceUserBinding.activate(id: '') }.to(
        raise_error(ArgumentError)
      )

      expect { Trusona::DeviceUserBinding.activate(id: 'some-id') }.to_not(
        raise_error
      )
    end

    it 'tells the worker to update the existing record' do
      stub = double(Trusona::Workers::DeviceUserBindingActivator)

      allow(Trusona::Workers::DeviceUserBindingActivator).to(
        receive(:new)
      ).and_return(
        stub
      )

      expect(stub).to receive(:activate).with(id: 'some-id')

      Trusona::DeviceUserBinding.activate(id: 'some-id')
    end
  end
end
