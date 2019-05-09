# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::PairedTruCode do
  before do
    @valid_params = {
      id: SecureRandom.uuid,
      identifier: 'any random thing'
    }
  end

  describe 'using the TruCode with the Trusona API' do
    it 'can represent itself as JSON' do
      sut = Trusona::Resources::PairedTruCode.new(@valid_params)
     
      json = sut.to_json

      expect(json).to eq(JSON(@valid_params))
    end
  end

  it 'should expose the identifier' do
    sut = Trusona::Resources::PairedTruCode.new(@valid_params)
    
    expect(sut.identifier).to eq 'any random thing'
  end
end
