# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::TruCodeMapper do
  describe 'building TruCodes from API responses' do
    before do
      @response_body = {
        payload: 'payload',
        id: '12345'
      }
      @existing = Trusona::Resources::TruCode.new(relying_party_id: 'rp-1')
    end

    it 'should properly map the TruCode' do
      sut = Trusona::Mappers::TruCodeMapper.new
      result = sut.map(
        @response_body,
        @existing.to_h
      )

      expect(result.id).to eq('12345')
      expect(result.payload).to eq('payload')
    end
  end
end
