# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::BaseResource do
  describe 'validity' do
    it 'is valid by default' do
      expect(Trusona::Resources::BaseResource.new.valid?).to be_truthy
    end
  end
  describe 'representing the resource' do
    it 'is representable as json' do
      Trusona::Resources::BaseResource.new.to_json
    end

    it 'is representable as a hash' do
      Trusona::Resources::BaseResource.new.to_h
    end
  end
  describe 'omnipresent resource properties' do
    it 'should always have a readable id' do
      Trusona::Resources::BaseResource.new.id
    end

    context 'when the id is empty' do
      it 'should be nil' do
        expect(Trusona::Resources::BaseResource.new.id).to be_nil
      end
    end

    context 'when the id is present' do
      it 'should be returned' do
        expect(Trusona::Resources::BaseResource.new(id: '1').id).to eq('1')
      end
    end
  end
end
