# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::DeviceFinder do
  describe 'creating a Device Finder' do
    it 'optionally accepts a service' do
      Trusona::Workers::DeviceFinder.new(service: double)
    end

    it 'uses a default service' do
      expect(Trusona::Services::DevicesService).to receive(:new)
      Trusona::Workers::DeviceFinder.new
    end
  end

  describe 'finding a specific device' do
    it 'requires an identifier' do
      sut = Trusona::Workers::DeviceFinder.new

      expect { sut.find(nil) }.to(
        raise_error(ArgumentError, 'A device identifier is required.')
      )
    end

    it 'creates a new Device resource' do
      expect(Trusona::Resources::Device).to(
        receive(:new).with(id: '1').and_call_original
      )
      stub = double(Trusona::Services::DevicesService, get: double)

      sut = Trusona::Workers::DeviceFinder.new(service: stub)
      sut.find('1')
    end

    it 'tells the service to get the Device' do
      result = double
      mock = double(get: result)

      sut = Trusona::Workers::DeviceFinder.new(service: mock)
      expect(sut.find('1')).to(eq(result))
    end
  end
end
