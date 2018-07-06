# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::UserIdentifier do
  before do
    @valid_params = {
      identifier: 'dXNlckBleGFtcGxlLmNvbQ==',
      trusona_id: '123456789'
    }
  end

  describe 'using the UserIdentifier with the Trusona API' do
    it 'can represent itself as JSON' do
      sut = Trusona::Resources::UserIdentifier.new(@valid_params)

      expect(sut.to_json).to eq(JSON(@valid_params))
    end
  end

  describe 'exposing parameters of the resource' do
    before do
      @sut = Trusona::Resources::UserIdentifier.new(@valid_params)
    end
    it 'should return the properties of the resource' do
      expect(@sut.identifier).to eq(@valid_params[:identifier])
      expect(@sut.trusona_id).to eq(@valid_params[:trusona_id])

      expect(@sut.to_h).to eq(@valid_params)
    end

    it 'should have a trusona_id' do
      expect(@sut.trusona_id).to eq(@valid_params[:trusona_id])
    end

    it 'should have an identifier' do
      expect(@sut.identifier).to eq(@valid_params[:identifier])
    end
  end

  describe 'validating a trusonafication' do
    context 'when all required parameters are present' do
      it 'should be valid' do
        sut = Trusona::Resources::UserIdentifier.new(@valid_params)
        expect(sut.valid?).to be_truthy
      end
    end

    context 'when there is no identifier' do
      it 'should not be valid' do
        @valid_params.delete(:identifier)
        sut = Trusona::Resources::UserIdentifier.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when there is no trusona_id' do
      it 'should not be valid' do
        @valid_params.delete(:trusona_id)
        sut = Trusona::Resources::UserIdentifier.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end
  end
end
