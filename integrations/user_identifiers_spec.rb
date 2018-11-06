# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Trusona User Identifiers' do
  before do
    @identifier = Trusona::Resources::UserIdentifier.new(identifier: 'am9uZXNAdGFjb3MubmV0Cg==', trusona_id: '264683802')
  end

  describe 'retreiving a user identifier' do
    context 'when no identifier exists' do
      it 'then we should see a Trusona::ResourceNotFound error raised' do
        expect { Trusona::UserIdentifier.find_by(identifier: 'asdf') }.to(
          raise_error(Trusona::ResourceNotFoundError)
        )
      end
    end

    xcontext 'when a valid identifier exists' do
      it 'should be successful' do
        res = Trusona::UserIdentifier.find_by(identifier: @identifier.identifier)
        expect(res.trusona_id).to eq @identifier.trusona_id
      end
    end
  end
end
