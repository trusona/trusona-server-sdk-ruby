# frozen_string_literal: true

RSpec.describe Trusona::UserIdentifier do
  describe 'Finding User Identifiers' do
    it 'should require a way to find the user' do
      expect { Trusona::UserIdentifier.find_by }.to raise_error(
        ArgumentError
      )
    end
  end
end
