# frozen_string_literal: true

require_relative 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Trusonafications' do
  before do
    @parameters = {
      resource: 'integration test suite',
      action: 'verify',
      email: ENV['INTEGRATION_TEST_EMAIL']
    }

    @timeout = 5

    @buster = Buster.new
  end
  describe 'creating a trusonafication for a known trusona user' do
    before do
      @trusonafication = Trusona::EssentialTrusonafication.create(
        params: @parameters, timeout: @timeout
      )
    end

    it 'just works' do
      expect(@trusonafication.status).to eq(:in_progress)
      expect(@trusonafication.email).to eq(ENV['INTEGRATION_TEST_EMAIL'])
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
  describe 'creating a trusonafication without a level' do
    it 'as expected, does not work' do
      expect {
        Trusona::Trusonafication.create(
          params: @parameters, timeout: @timeout
        )
      }.to raise_error(Trusona::InvalidResourceError)
    end
  end
  describe 'creating a trusonafication with a callback url' do
    it 'should POST to the URL when the trusonafication is completed' do
      callback_id = SecureRandom.uuid

      @parameters[:callback_url] = @buster.callback_url(callback_id)
      @parameters[:expires_at] = 1.second.from_now

      Trusona::EssentialTrusonafication.create(params: @parameters, timeout: @timeout)

      wait_for do
        callback_result = @buster.callback_result(callback_id)
        callback_result.code
      end.to eq(200)
    end
  end
end
# rubocop:enable Metrics/BlockLength
