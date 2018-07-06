# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Trusonafications' do
  before do
    Trusona.config do |c|
      c.tru_codes_host = ENV['TRUCODES_HOST']
      c.api_host       = ENV['TRUSONA_API_HOST']
      c.secret         = ENV['TRUSONA_SECRET']
      c.token          = ENV['TRUSONA_TOKEN']
    end

    @parameters = {
      resource: 'integration test suite',
      action: 'verify',
      user_identifier: 'claytonhauz@gmail.com'
    }

    @timeout = 5
  end
  describe 'creating a trusonafication for a known trusona user' do
    before do
      @trusonafication = Trusona::EssentialTrusonafication.create(
        params: @parameters, timeout: @timeout
      )
    end

    it 'just works' do
      expect(@trusonafication.status).to eq(:in_progress)
      expect(@trusonafication.user_identifier).to eq('claytonhauz@gmail.com')
      expect(@trusonafication.resource).to eq('integration test suite')
      expect(@trusonafication.action).to eq('verify')
      expect(@trusonafication.level).to eq(2)
      expect(@trusonafication.expires_at).to be
    end

    context 'and when you try to find that same trusonafication' do
      it 'that just works too' do
        @found = Trusona::Trusonafication.find(@trusonafication.id)
        expect(@found.trusona_id).to eq(@trusonafication.trusona_id)
        expect(@found.status).to eq(@trusonafication.status)
        expect(@found.resource).to eq(@trusonafication.resource)
        expect(@found.action).to eq(@trusonafication.action)
        expect(@found.level).to eq(@trusonafication.level)
      end
    end
  end
  describe 'creating a trusonafication for an unknown trusona user' do
    it 'as expected, does not work' do
      @parameters[:user_identifier] = "#{Time.now.to_i}@example.com"
      trusonafication = Trusona::Trusonafication.create(
        params: @parameters, timeout: @timeout
      )

      expect(trusonafication.trusona_id).to_not be
    end
  end
end
# rubocop:enable Metrics/BlockLength
