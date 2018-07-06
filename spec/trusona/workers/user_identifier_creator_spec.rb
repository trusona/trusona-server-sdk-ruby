# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::UserIdentifierCreator do
  describe 'creating a UserIdentifierCreator' do
    it 'optionally accepts a service' do
      Trusona::Workers::UserIdentifierCreator.new(service: double)
    end

    it 'uses a default service' do
      Trusona::Workers::UserIdentifierCreator.new
    end

    it 'requires an identifier' do
      pass_through_service = double(get: double, create: double)
      sut = Trusona::Workers::UserIdentifierCreator.new(service: pass_through_service)
      expect { sut.create }.to raise_error(ArgumentError)
    end
  end
end
