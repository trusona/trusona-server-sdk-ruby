# frozen_string_literal: true

require_relative 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Trusona User Accounts' do
  before do
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
