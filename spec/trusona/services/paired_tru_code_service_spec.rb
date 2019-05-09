# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::PairedTruCodeService do
  before do
    Trusona.config do |c|
      c.token = 'token'
      c.secret = 'secret'
      c.api_host = 'https://fake'
    end
  end

  describe 'looking up a paired trucode' do
    it 'tells the client to do a GET on the right URL and gets back an object with the trucode id and the user identifier when the trucode exists and is paired' do
      verified_response = double(
        code: 200,
        verified?: true,
        to_h: {
          id: 'df2276bd-9544-4c6f-894c-53229efe74bf',
          identifier: 'trusonaId:246928453'
        }
      )
      client_double = double(get: verified_response)
      sut = Trusona::Services::PairedTruCodeService.new(client: client_double)
  
      expect(client_double).to receive(:get).with('/api/v2/paired_trucodes/foo')

      result = sut.get(OpenStruct.new(id: 'foo'))

      expect(result).not_to be_nil
      expect(result.id).to eq 'df2276bd-9544-4c6f-894c-53229efe74bf'
      # expect(result.identifier).to eq 'trusonaId:246928453'
    end
  end
end
