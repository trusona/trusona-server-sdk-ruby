# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Device do
  describe 'finding a device given an identifier' do
    it 'requires a device identifier' do
      expect { Trusona::Device.find(id: nil) }.to(
        raise_error(ArgumentError, 'A Device identifier is required.')
      )
    end

    it 'tells the worker to find that specific device' do
      spy = double(Trusona::Workers::DeviceFinder)
      allow(Trusona::Workers::DeviceFinder).to(
        receive(:new).and_return(spy)
      )

      expect(spy).to receive(:find).with('r1ByVyVKJ7TRgU0RPX0-THMTD_CO3VrCSNqLpJFmhms')

      Trusona::Device.find(id: 'r1ByVyVKJ7TRgU0RPX0-THMTD_CO3VrCSNqLpJFmhms')
    end
  end
end
