# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::IdentityDocumentFinder do
  describe 'creating an Identity Document Finder' do
    it 'optionally accepts a service' do
      Trusona::Workers::IdentityDocumentFinder.new(service: double)
    end

    it 'uses a default service' do
      expect(Trusona::Services::IdentityDocumentsService).to receive(:new)
      Trusona::Workers::IdentityDocumentFinder.new
    end
  end

  describe 'finding all documents for a user identifier' do
    it 'requires a user identifier' do
      sut = Trusona::Workers::IdentityDocumentFinder.new

      expect { sut.find_all(nil) }.to(
        raise_error(ArgumentError, 'A user identifier is required.')
      )
    end

    it 'tells the service to get the Identity Documents' do
      mock = double(Trusona::Services::IdentityDocumentsService)

      sut = Trusona::Workers::IdentityDocumentFinder.new(service: mock)

      expect(mock).to receive(:index).with('user-123')

      sut.find_all('user-123')
    end
  end

  describe 'finding a specific identity document' do
    it 'requires an Identity Document id' do
      sut = Trusona::Workers::IdentityDocumentFinder.new

      expect { sut.find(nil) }.to(
        raise_error(ArgumentError, 'An Identity Document id is required.')
      )
    end

    it 'creates a new Identity Document resource' do
      expect(Trusona::Resources::IdentityDocument).to(
        receive(:new).with(id: '1').and_call_original
      )

      stub = double(Trusona::Services::IdentityDocumentsService, get: double)
      sut = Trusona::Workers::IdentityDocumentFinder.new(service: stub)
      sut.find('1')
    end

    it 'tells the service to get the Identity document' do
      mock = double(get: double)

      expect(mock).to(receive(:get).and_return(double))

      sut = Trusona::Workers::IdentityDocumentFinder.new(service: mock)

      sut.find('1')
    end
  end
end
