# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Api::HashedMessage do
  before do
    Trusona.config do |c|
      c.api_host = 'testing.local'
      c.secret = 'my secret'
      c.token  = 'my token'
    end

    @valid = {
      method: 'GET',
      body: JSON(id: SecureRandom.uuid),
      content_type: Trusona::Api::HTTPClient::CONTENT_TYPE,
      path: '/api/v1/internal/widgets',
      date: Time.now.to_s,
      secret: 'my secret',
      token: 'my token'
    }
  end

  describe 'generating a message hash' do
    it 'should return a signed authorization header' do
      expect(Trusona::Api::HashedMessage.new(@valid).auth_header).to be
    end
  end

  describe 'creating a hashed message instance' do
    it 'should require an HTTP method' do
      invalid = @valid.merge(method: nil)
      expect do
        Trusona::Api::HashedMessage.new(invalid)
      end.to raise_error(ArgumentError)

      expect do
        Trusona::Api::HashedMessage.new(@valid)
      end.not_to raise_error
    end

    it 'should require a valid HTTP method' do
      invalid = @valid.merge(method: 'TEAPOT')
      expect do
        Trusona::Api::HashedMessage.new(invalid)
      end.to raise_error(ArgumentError)

      expect do
        Trusona::Api::HashedMessage.new(@valid.merge(method: 'get'))
      end.not_to raise_error

      expect do
        Trusona::Api::HashedMessage.new(@valid.merge(method: '    Get '))
      end.not_to raise_error

      expect do
        Trusona::Api::HashedMessage.new(@valid)
      end.not_to raise_error
    end

    it 'should allow empty HTTP bodies' do
      expect do
        Trusona::Api::HashedMessage.new(@valid.merge(body: {}))
      end.not_to raise_error
    end

    it 'should allow nil HTTP bodies' do
      expect do
        Trusona::Api::HashedMessage.new(@valid.merge(body: nil))
      end.not_to raise_error
    end

    it 'should require a path' do
      invalid = @valid.merge(path: nil)
      expect do
        Trusona::Api::HashedMessage.new(invalid)
      end.to raise_error(ArgumentError)

      expect do
        Trusona::Api::HashedMessage.new(@valid)
      end.not_to raise_error
    end

    context 'with a provided date' do
      context 'and the date is invalid' do
        it 'should use the current time' do
          expect do
            Trusona::Api::HashedMessage.new(
              @valid.merge(date: 'not a date')
            )
          end.not_to raise_error
        end
      end
    end
  end
end
