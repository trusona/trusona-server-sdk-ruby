# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::User do
  describe 'deactivating a user' do
    it 'tells the user deactivator worker to deactivate that specific user' do
      user_identifier = 'blars_tacoman'
      spy = double(Trusona::Workers::UserDeactivator)

      allow(Trusona::Workers::UserDeactivator).to receive(:new)
        .and_return(spy)

      expect(spy).to receive(:deactivate)
        .with(user_identifier)

      Trusona::User.deactivate(user_identifier: user_identifier)
    end
  end
end
