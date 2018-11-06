# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Trusona User Accounts' do
  before do
    Trusona.config do |c|
      c.tru_codes_host = ENV['TRU_CODES_HOST']
      c.api_host       = ENV['TRUSONA_API_HOST']
      c.secret         = ENV['TRUSONA_SECRET']
      c.token          = ENV['TRUSONA_TOKEN']
    end

    @account_lookup = { trusona_id: '167791378' }
    @email_lookup   = { email: ENV['INTEGRATION_TEST_EMAIL'] }
  end

  describe 'retrieving a user account with their Trusona ID' do
    context 'when the user account exists and can be found' do
    end

    context 'when no user account exists for the given Trusona ID' do
      it 'then we should see a Trusona::ResourceNotFound error raised' do
        expect { Trusona::UserAccounts.find_by(@account_lookup) }.to(
          raise_error(Trusona::ResourceNotFoundError)
        )
      end
    end
  end

  describe 'searching for a user account using their email' do
    context 'when a user account exists with the given email' do
    end

    context 'when no user accounts exist with the given email' do
    end
  end
end
