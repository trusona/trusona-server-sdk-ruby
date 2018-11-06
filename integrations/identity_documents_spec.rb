# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Identity Documents' do
  describe 'finding all documents for a user identifier' do
    it 'should work' do
      result = Trusona::IdentityDocument.all(user_identifier: SecureRandom.uuid)
      expect(result).to eq([])
    end
  end

  describe 'finding a single identity document' do
    it 'should work' do
      result = Trusona::IdentityDocument.find(id: SecureRandom.uuid)
      expect(result).to eq(nil)
    end
  end
end
