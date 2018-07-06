# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::UserAccounts do
  describe 'Finding User Accounts' do
    before do
      allow(Trusona::Workers::UserAccountFinder).to receive(:new).and_return(
        double(find: double)
      )
    end

    it 'should require a way to find the user' do
      expect { Trusona::UserAccounts.find_by }.to raise_error(
        ArgumentError
      )
    end

    it 'should optionally accept a trusona id' do
      opts = { trusona_id: 123 }
      expect { Trusona::UserAccounts.find_by(opts) }.to_not raise_error
    end

    it 'should optionally accept an email' do
      opts = { email: 'user@example.com' }
      expect { Trusona::UserAccounts.find_by(opts) }.to_not raise_error
    end

    context 'when the options hash uses strings' do
      it 'should optionally accept a trusona id' do
        opts = { 'trusona_id' => 123 }
        expect { Trusona::UserAccounts.find_by(opts) }.to_not raise_error
      end

      it 'should optionally accept an email' do
        opts = { 'email' => 'user@example.com' }
        expect { Trusona::UserAccounts.find_by(opts) }.to_not raise_error
      end
    end

    context 'when searching with an email' do
      it 'should tell the worker to find the user' do
        opts = { email: 'user@example.com' }

        stub_worker = double

        expect(Trusona::Workers::UserAccountFinder).to(
          receive(:new)
        ).and_return(
          stub_worker
        )

        expect(stub_worker).to receive(:find).with(opts)

        Trusona::UserAccounts.find_by(opts)
      end
    end
  end
end
