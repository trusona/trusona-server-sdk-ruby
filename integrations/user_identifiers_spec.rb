# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Trusona User Identifiers' do
  before do
    # this depends on existing data in staging. if it fails, try running this:
    # insert into user_identifiers (identifier, trusona_id, created_at, updated_at, account_handle, relying_party_id)
    # values ('am9uZXNAdGFjb3MubmV0Cg==', '264683802', now(), now(), uuid_generate_v4(), '5dfc5568-fbd3-4c1c-80f6-d0cf3d9edc82')
    @identifier = Trusona::Resources::UserIdentifier.new(identifier: 'am9uZXNAdGFjb3MubmV0Cg==', trusona_id: '264683802')
  end

  describe 'retrieving a user identifier' do
    context 'when no identifier exists' do
      it 'then we should see a Trusona::ResourceNotFound error raised' do
        expect { Trusona::UserIdentifier.find_by(identifier: 'asdf') }.to(
          raise_error(Trusona::ResourceNotFoundError)
        )
      end
    end

    context 'when a valid identifier exists' do
      it 'should be successful' do
        res = Trusona::UserIdentifier.find_by(identifier: @identifier.identifier)
        expect(res.trusona_id).to eq @identifier.trusona_id
      end
    end
  end
end
