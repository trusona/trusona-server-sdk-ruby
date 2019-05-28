# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Trusona::PairedTruCode do
  before do
    Trusona.config do |config|
      config.token = 'token'
      config.secret = 'secret'
    end
    body =<<EOF
      {
        "id": "myid",
        "identifier": "myidentifier"
      }
EOF
    signature = 'ODQ1YmVjNTAxNWRhOTFiZTEwMDljOTc4Y2NmOTE4ZDU1YzY0NDQ2YzhkNWJiMjIyMzA0ZjhiYzdlNGI2NjlmNQ=='

    stub_request(:get, 'https://api.trusona.net/api/v2/paired_trucodes/abc123').
      to_return(status: 200, body: body, headers: {"x-signature" => signature})
  end
  context 'a trucode exists and is paired' do
    it 'loads the trucode' do
      paired_tru_code = Trusona::PairedTruCode.find('abc123')

      expect(paired_tru_code).not_to be_nil
      expect(paired_tru_code.id).to eq 'myid'
      expect(paired_tru_code.identifier).to eq 'myidentifier'
    end
  end
end
