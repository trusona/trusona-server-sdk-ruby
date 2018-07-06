# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::UserAccountFinder do
  describe 'finding user accounts' do
    it 'requires an email or trusona id' do
      pass_through_service = double(get: double, create: double)
      sut = Trusona::Workers::UserAccountFinder.new(
        user_accounts_service: pass_through_service,
        account_lookups_service: pass_through_service
      )

      expect { sut.find }.to raise_error(ArgumentError)
      expect { sut.find(foo: 'bar') }.to raise_error(ArgumentError)
      expect { sut.find(email: 'user@example.com') }.to_not raise_error
      expect { sut.find('email' => 'user@example.com') }.to_not raise_error
      expect { sut.find(trusona_id: 1) }.to_not raise_error
      expect { sut.find('trusona_id' => 1) }.to_not raise_error
    end

    context 'when a trusona id is provided' do
      it 'the UserAccounts service finds the user using the trusona id' do
        spy_service = double
        sut = Trusona::Workers::UserAccountFinder.new(
          user_accounts_service: spy_service
        )

        expect(spy_service).to receive(:get)
        sut.find(trusona_id: '12345')
      end
    end

    context 'when an email is provided' do
      it 'the Account Lookups Service finds the user user using the email' do
        spy_service = double(Trusona::Services::AccountLookupsService)
        sut = Trusona::Workers::UserAccountFinder.new(
          account_lookups_service: spy_service
        )

        expect(spy_service).to receive(:create)
        sut.find(email: 'user@example.com')
      end
    end
  end
end
