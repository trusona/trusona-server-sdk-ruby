# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::IdentityDocument do
  describe 'findining identity documents for a user' do
    it 'requires a user identifier' do
      expect { Trusona::IdentityDocument.all(user_identifier: nil) }.to(
        raise_error(ArgumentError, 'A user identifier is required.')
      )
    end

    it 'tells the worker to find all of the documents' do
      spy = double(Trusona::Workers::IdentityDocumentFinder)
      allow(Trusona::Workers::IdentityDocumentFinder).to(
        receive(:new).and_return(spy)
      )

      expect(spy).to receive(:find_all).with('bob-123')

      Trusona::IdentityDocument.all(user_identifier: 'bob-123')
    end
  end

  describe 'finding a single identity document given an ID' do
    it 'requires a identity document identifier' do
      expect { Trusona::IdentityDocument.find(id: nil) }.to(
        raise_error(
          ArgumentError,
          'An Identity Document identifier is required.'
        )
      )
    end

    it 'tells the worker to find that specific identity document' do
      spy = double(Trusona::Workers::IdentityDocumentFinder)
      allow(Trusona::Workers::IdentityDocumentFinder).to(
        receive(:new).and_return(spy)
      )

      expect(spy).to receive(:find).with('dl-456')

      Trusona::IdentityDocument.find(id: 'dl-456')
    end
  end
end
