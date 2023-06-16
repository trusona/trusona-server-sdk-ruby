# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::BaseMapper do
  describe 'mapping API responses to Resources' do
    before do
      @response   = { bar: 2 }
      @resource   = double(new: double)
      @existing   = { foo: 1 }
      @custom_map = { widget_id: :id }

      @sut = Trusona::Mappers::BaseMapper.new
      @sut.resource = @resource
    end

    it 'requires a response' do
      expect { @sut.map(nil, @resource) }.to raise_error(ArgumentError)
    end

    it 'requires a response that can be turned into a hash' do
      expect { @sut.map('', @resource) }.to raise_error(ArgumentError)
    end

    it 'optionally accepts an existing state of the resource' do
      @sut.map(@response, @existing)
    end

    it 'creates a new resource using the response' do
      @sut.resource = @resource
      expect(@resource).to receive(:new).with(@response.to_h)
      @sut.map(@response)
    end

    context 'when the response uses strings as keys' do
      it 'should correctly map the stringed keys' do
        stringed_response = { 'id' => 1 }
        expect(@resource).to receive(:new).with({id: 1})
        @sut.map(stringed_response)
      end
    end

    context 'when specifiying an existing resource' do
      it 'the resource should be able to be turned into a hash' do
        existing = double(empty?: false)
        expect { @sut.map(@response, existing) }.to raise_error(
          ArgumentError
        )
      end

      it 'should merge the existing values into the response' do
        existing = { id: 2 }
        response = { name: 'widget' }
        expect(@resource).to receive(:new).with({id: 2, name: 'widget'})
        @sut.map(response, existing)
      end

      it 'should overwrite existing values with response values' do
        existing = { id: 2, name: 'foobar' }
        response = { id: 2, name: 'bazqux' }
        expect(@resource).to receive(:new).with({id: 2, name: 'bazqux'})
        @sut.map(response, existing)
      end

      it 'should ignore existing nil values' do
        existing = { id: 2, name: nil }
        response = { name: 'widget' }
        expect(@resource).to receive(:new).with({id: 2, name: 'widget'})
        @sut.map(response, existing)
      end
    end

    context 'when the response keys do not match the resource attributes' do
      it 'the custom mapping should be used to populate mismatched values' do
        response = { widget_id: 1, name: 'widget' }
        expect(@resource).to receive(:new).with({id: 1, name: 'widget'})
        @sut.custom_mappings = { widget_id: :id }
        @sut.map(response, {})
      end
    end

    context 'when the response is a list' do
      it 'should apply the mapping to each item of the list' do
        response = double(Trusona::Api::VerifiedResponse, to_h: [@response])
        expect(@resource).to receive(:new).with(@response)
        @sut.map(response)
      end

      context 'when the response is empty' do
        it 'should return an empty list' do
          response = double(Trusona::Api::VerifiedResponse, to_h: [])
          expect(@sut.map(response)).to be_empty
        end
      end
    end
  end
end
