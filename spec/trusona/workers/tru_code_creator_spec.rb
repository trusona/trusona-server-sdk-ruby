# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::TruCodeCreator do
  describe 'creating a TruCodeCreator worker' do
    it 'optionally accepts a TruCode service' do
      Trusona::Workers::TruCodeCreator.new(double)
    end
  end

  describe 'creating TruCodes' do
    before do
      @valid_tru_code = double(valid?: true)
      @created_tru_code = double(
        relying_party_id: 'rp-1',
        payload: 'payload',
        id: '1234'
      )
      @successful_service_stub = double(create: @created_tru_code)
    end

    it 'requires a TruCode' do
      sut = Trusona::Workers::TruCodeCreator.new(@successful_service_stub)
      sut.create(double)
    end

    it 'tells the TruCode service to create the code' do
      spy = @successful_service_stub
      code = @valid_tru_code
      sut = Trusona::Workers::TruCodeCreator.new(spy)
      expect(spy).to(
        receive(:create).with(code)
      )
      sut.create(code)
    end

    context 'when the TruCode was created' do
      it 'returns the created TruCode' do
        tru_codes_service = double(create: @created_tru_code)
        sut = Trusona::Workers::TruCodeCreator.new(tru_codes_service)
        expect(sut.create(@created_tru_code)).to eq(@created_tru_code)
      end
    end
  end
end
