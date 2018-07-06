# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::UserIdentifierFinder do
  describe 'creating a UserIdentifierFinder' do
    it 'optionally accepts a service' do
      Trusona::Workers::UserIdentifierFinder.new(service: double)
    end

    it 'uses a default service' do
      Trusona::Workers::UserIdentifierFinder.new
    end

    it 'requires an identifier' do
      pass_through_service = double(get: double, create: double)
      sut = Trusona::Workers::UserIdentifierFinder.new(service: pass_through_service)

      expect { sut.find }.to raise_error(ArgumentError)
      expect { sut.find(foo: 'bar') }.to raise_error(ArgumentError)
      expect { sut.find(identifier: 'user@example.com') }.to_not raise_error
      expect { sut.find('identifier' => 'user@example.com') }.to_not raise_error
    end
  end

  describe 'finding a user identifier' do
    context 'when a user_identifier is provided' do
      it 'the UserIdentifier service finds the user using the identifier' do
        spy_service = double
        sut = Trusona::Workers::UserIdentifierFinder.new(
          service: spy_service
        )

        expect(spy_service).to receive(:get)
        sut.find(identifier: 'user@example.com')
      end
    end
  end
end
