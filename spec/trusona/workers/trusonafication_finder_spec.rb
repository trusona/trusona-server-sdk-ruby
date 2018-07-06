# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::TrusonaficationFinder do
  before do
    @passthrough_service = double(
      Trusona::Services::TrusonaficationService, get: double
    )
  end
  describe 'creating a finder' do
    it 'optionally accepts a service' do
      Trusona::Workers::TrusonaficationFinder.new(service: @passthrough_service)
    end

    it 'uses a default service' do
      allow(Trusona::Services::TrusonaficationService).to(
        receive(:new)
      ).and_return(@passthrough_service)
      expect(Trusona::Services::TrusonaficationService).to(receive(:new))
      Trusona::Workers::TrusonaficationFinder.new
    end
  end

  describe 'finding trusonafications' do
    it 'requires a trusonafication id' do
      sut = Trusona::Workers::TrusonaficationFinder.new(
        service: @passthrough_service
      )
      expect { sut.find(nil) }.to raise_error(Trusona::InvalidResourceError)
      expect { sut.find('') }.to raise_error(Trusona::InvalidResourceError)

      expect { sut.find('1') }.to_not raise_error
    end

    it 'tells the service to get the trusonafication' do
      spy = double(Trusona::Services::TrusonaficationService, get: double)
      expect(spy).to(receive(:get))

      Trusona::Workers::TrusonaficationFinder.new(service: spy).find('1')
    end
  end
end
