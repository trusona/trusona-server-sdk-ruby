# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::TrusonaficationCanceler do
  before do
    @passthrough_service = double(
      Trusona::Services::TrusonaficationService, delete: double
    )
  end
  describe 'creating a canceler' do
    it 'optionally accepts a service' do
      Trusona::Workers::TrusonaficationCanceler.new(service: @passthrough_service)
    end

    it 'uses a default service' do
      allow(Trusona::Services::TrusonaficationService).to(
        receive(:new)
      ).and_return(@passthrough_service)
      expect(Trusona::Services::TrusonaficationService).to(receive(:new))
      Trusona::Workers::TrusonaficationFinder.new
    end
  end

  describe 'canceling a trusonafication' do
    it 'requires a trusonafication id' do
      sut = Trusona::Workers::TrusonaficationCanceler.new(
        service: @passthrough_service
      )
      expect { sut.cancel(nil) }.to raise_error(Trusona::InvalidResourceError)
      expect { sut.cancel('') }.to raise_error(Trusona::InvalidResourceError)
      expect { sut.cancel(' ') }.to raise_error(Trusona::InvalidResourceError)
      expect { sut.cancel('1') }.to_not raise_error
    end

    it 'tells the service to delete the trusonafication' do
      spy = double(Trusona::Services::TrusonaficationService, delete: double)
      expect(spy).to(receive(:delete))

      Trusona::Workers::TrusonaficationCanceler.new(service: spy).cancel('1')
    end
  end
end
