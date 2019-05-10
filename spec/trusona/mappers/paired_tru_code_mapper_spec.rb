# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::PairedTruCodeMapper do
  describe 'building PairedTruCodes from API responses' do
    before do
      @response_body = {
        id: 'df2276bd-9534-4c6f-894c-53229efe74bf',
        identifier: 'trusonaId:246228473'
      }
    end

    it 'maps a JSON response to a PairedTruCode' do
      sut = Trusona::Mappers::PairedTruCodeMapper.new
      result = sut.map(@response_body)

      expect(result).not_to be_nil
      expect(result.id).to eq 'df2276bd-9534-4c6f-894c-53229efe74bf'
      expect(result.identifier).to eq 'trusonaId:246228473'
    end
  end
end