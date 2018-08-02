# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::UserDeactivator do
  describe 'creating a UserIdentifierCreator' do
    it 'uses a default service' do
      Trusona::Workers::UserDeactivator.new
    end

    it 'optionally accepts a service' do
      Trusona::Workers::UserDeactivator.new(service: double)
    end
  end

  describe 'deactivating a user' do
    before do
      @mock_service = double
      @sut = Trusona::Workers::UserDeactivator.new(service: @mock_service)
    end

    it 'requires a user identifier' do
      [nil, ''].each do |user_identifier|
        expect { @sut.deactivate(user_identifier) }.to(
          raise_error(ArgumentError, "The user's identifier is required")
        )
      end
    end

    it 'calls delete on the service' do
      user_identifier = 'blars_tacoman'
      mock_user = double

      allow(Trusona::Resources::User).to receive(:new)
        .with(user_identifier: user_identifier)
        .and_return(mock_user)

      expect(@mock_service).to receive(:delete)
        .with(mock_user)

      @sut.deactivate(user_identifier)
    end
  end
end
