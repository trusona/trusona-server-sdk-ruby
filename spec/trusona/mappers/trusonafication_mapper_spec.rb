# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::TrusonaficationMapper do
  describe 'building Trusonafications from API responses' do
    before do
      @response_body = {
        'trusona_id' => '928556422',
        'device_identifier' => 'device-1',
        'user_identifier' => 'andre3000',
        'action' => 'enhance',
        'resource' => 'claydentity',
        'desired_level' => 1,
        'accepted_level' => nil,
        'id' => '4f0b75f1-1ae8-47f6-9b50-65ec1b1bc8df',
        'status' => 'IN_PROGRESS',
        'email' => 'african-tiger@taco.jones',
        'created_at' => 'Tue, 01 Jan 2013 04:39:43 GMT',
        'updated_at' => 'Tue, 01 Jan 2013 04:39:43 GMT',
        'result' => {
          'id' => '4f0b75f1-1ae8-47f6-9b50-65ec1b1bc8df',
          'accepted_level' => 1
        }
      }
    end

    it 'should properly map the trusonafication' do
      sut = Trusona::Mappers::TrusonaficationMapper.new
      result = sut.map(@response_body)

      expect(result.device_identifier).to eq('device-1')
      expect(result.user_identifier).to eq('andre3000')
      expect(result.action).to eq('enhance')
      expect(result.resource).to eq('claydentity')
      expect(result.email).to eq('african-tiger@taco.jones')
      expect(result.level).to eq(1)
      expect(result.id).to eq('4f0b75f1-1ae8-47f6-9b50-65ec1b1bc8df')
    end
  end
end
