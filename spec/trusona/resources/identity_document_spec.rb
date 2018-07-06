# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::IdentityDocument do
  before do
    @valid_params = {
      document_hash: 'the-hash',
      id: '1234',
      type: 'AAMVA_DRIVERS_LICENSE',
      verification_status: 'UNVERIFIED',
      user_identifier: 'user-123'
    }
    @sut = Trusona::Resources::IdentityDocument.new(@valid_params)
  end

  describe 'attributes' do
    it 'should include a hash of the document data' do
      expect(@sut.document_hash).to(eq(@valid_params[:document_hash]))
    end

    it 'should include an id for the document' do
      expect(@sut.id).to(eq(@valid_params[:id]))
    end

    it 'should include the type of document' do
      expect(@sut.type).to(eq(@valid_params[:type]))
    end

    it 'should include the verification status of the document' do
      expect(@sut.verification_status).to(eq(@valid_params[:verification_status]))
    end

    it 'should include the user identifier associated with the document' do
      expect(@sut.user_identifier).to(eq(@valid_params[:user_identifier]))
    end
  end

  describe 'as JSON' do
    it 'correctly maps all fields to the expected values' do
      result = JSON.parse(@sut.to_json)

      expect(result['hash']).to(eq(@sut.document_hash))
      expect(result['id']).to(eq(@sut.id))
      expect(result['type']).to(eq(@sut.type))
      expect(result['verification_status']).to(eq(@sut.verification_status))
      expect(result['user_identifier']).to(eq(@sut.user_identifier))
    end
  end
end
