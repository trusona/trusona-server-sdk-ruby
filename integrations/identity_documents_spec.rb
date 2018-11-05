# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Identity Documents' do
  before do
    Trusona.config do |c|
      c.tru_codes_host = ENV['TRU_CODES_HOST']
      c.api_host       = ENV['TRUSONA_API_HOST']
      c.secret         = ENV['TRUSONA_SECRET']
      c.token          = ENV['TRUSONA_TOKEN']
    end
  end

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
