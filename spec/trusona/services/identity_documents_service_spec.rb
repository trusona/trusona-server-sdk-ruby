# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::IdentityDocumentsService do
  describe 'getting the index' do
    it 'uses a query string parameter' do
      response = double(
        Trusona::Api::VerifiedResponse,
        to_h: [],
        code: 200,
        verified?: true
      )
      mock = double(Trusona::Api::HTTPClient, get: response)

      sut = Trusona::Services::IdentityDocumentsService.new(
        client: mock
      )

      expect(mock).to(
        receive(:get).with(
          '/api/v2/identity_documents?user_identifier=user-1234'
        ).and_return(response)
      )

      sut.index('user-1234')
    end
  end

  context 'when no identity documents are found' do
    it 'an empty list is returned' do
      response = double(
        Trusona::Api::VerifiedResponse,
        to_h: [],
        code: 200,
        verified?: true
      )
      stub = double(Trusona::Api::HTTPClient, get: response)

      sut = Trusona::Services::IdentityDocumentsService.new(
        client: stub
      )

      expect(sut.index('user-1234')).to(eq([]))
    end
  end

  describe 'getting a single identity document' do
    context 'when the document cannot be found' do
      it 'an exception is not raised' do
        response = double(
          Trusona::Api::VerifiedResponse,
          to_h: {},
          code: 404,
          verified?: true
        )
        stub = double(Trusona::Api::HTTPClient, get: response)

        sut = Trusona::Services::IdentityDocumentsService.new(
          client: stub
        )

        resource = Trusona::Resources::IdentityDocument.new(id: '1')
        expect { sut.get(resource) }.to_not raise_error

        expect(sut.get(resource)).to be_nil
      end
    end
  end
end
