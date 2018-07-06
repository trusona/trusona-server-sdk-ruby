# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::TruCodeFinder do
  describe 'creating a TruCodeFinder' do
    it 'optionally accepts a TruCodeService' do
      Trusona::Workers::TruCodeFinder.new(service: double)
    end

    it 'uses a default service' do
      Trusona::Workers::TruCodeFinder.new
    end
  end

  describe 'finding a TruCode' do
    before do
      @dummy_service = double(get: double)
    end

    context 'when the TruCode id is empty' do
      it 'should raise an error' do
        expect do
          Trusona::Workers::TruCodeFinder.new.find(nil)
        end.to raise_error(ArgumentError)
      end
    end

    it 'creates a temporary resource to help find the TruCode' do
      id = 1234
      expect(Trusona::Resources::BaseResource).to receive(:new).with(
        id: id
      ).and_call_original

      sut = Trusona::Workers::TruCodeFinder.new(service: @dummy_service)
      sut.find(id)
    end

    it 'tells the service to get the TruCode' do
      id = 4567
      resource = Trusona::Resources::BaseResource.new(id: 4567)
      service  = double(get: nil)

      allow(Trusona::Resources::BaseResource).to receive(:new).and_return(
        resource
      )

      expect(service).to receive(:get).with(resource)

      sut = Trusona::Workers::TruCodeFinder.new(service: service)
      sut.find(id)
    end
  end
end
