# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Trusona::Api::HTTPClient do
  describe 'Trying to use the client with no config' do
    it 'should raise a helpful error' do
      expect {
        Trusona::Api::HTTPClient.new
      }.to raise_error Trusona::ConfigurationError
    end
  end

  describe 'GETting' do
    before do
      Trusona.config do |c|
        c.api_host = 'example.com'
      end
      @path = '/api/v1/widgets'
      @params = { resource: { name: 'w-1000' } }
    end

    it 'should build a signed request' do
      # bad, mocking what we don't own
      allow(HTTParty).to receive(:get)
      allow(Trusona::Api::VerifiedResponse).to receive(:new)

      # bad, should be injecting this dependency
      expect(Trusona::Api::SignedRequest).to receive(:new).with(
        @path,
        @params,
        'GET',
        'https://example.org'
      ).and_return(double(uri: '', body: '', headers: ''))

      sut = Trusona::Api::HTTPClient.new('https://example.org')
      sut.get(@path, @params)
    end

    it 'should tell the http library to complete the request' do
      # bad, should be injecting this dependency
      allow(Trusona::Api::SignedRequest).to receive(:new).and_return(
        double(uri: 'uri', body: 'body', headers: 'headers')
      )

      allow(Trusona::Api::VerifiedResponse).to receive(:new)

      expect(HTTParty).to receive(:get).with(
        'uri',
        body: 'body',
        headers: 'headers'
      )

      sut = Trusona::Api::HTTPClient.new
      sut.get(@path, @params)
    end

    it 'should verify the response' do
      unverified = double
      allow(Trusona::Api::SignedRequest).to receive(:new).and_return(
        double(uri: 'uri', body: 'body', headers: 'headers')
      )

      allow(HTTParty).to receive(:get).and_return(
        unverified
      )

      expect(Trusona::Api::VerifiedResponse).to receive(:new).with(unverified).and_return(double)

      sut = Trusona::Api::HTTPClient.new
      sut.get(@path, @params)
    end
  end

  describe 'POSTing' do
    before do
      @path = '/api/v1/widgets'
      @params = { resource: { name: 'w-1000' } }
    end

    it 'should build a signed request' do
      # bad, mocking what we don't own
      allow(HTTParty).to receive(:post)

      # bad, should be injecting this dependency
      expect(Trusona::Api::SignedRequest).to receive(:new).with(
        @path,
        @params,
        'POST',
        'https://example.org'
      ).and_return(double(uri: '', body: '', headers: ''))

      # and this one
      allow(Trusona::Api::VerifiedResponse).to receive(:new)

      sut = Trusona::Api::HTTPClient.new('https://example.org')
      sut.post(@path, @params)
    end

    it 'should tell the http library to complete the request' do
      # bad, should be injecting this dependency
      allow(Trusona::Api::SignedRequest).to receive(:new).and_return(
        double(uri: 'uri', body: 'body', headers: 'headers')
      )

      # and this one
      allow(Trusona::Api::VerifiedResponse).to receive(:new)

      expect(HTTParty).to receive(:post).with(
        'uri',
        body: 'body', headers: 'headers'
      )

      sut = Trusona::Api::HTTPClient.new
      sut.post(@path, @params)
    end

    it 'should verify the response' do
      unverified = double
      allow(Trusona::Api::SignedRequest).to receive(:new).and_return(
        double(uri: 'uri', body: 'body', headers: 'headers')
      )

      allow(HTTParty).to receive(:post).and_return(
        unverified
      )

      expect(Trusona::Api::VerifiedResponse).to receive(:new).with(unverified).and_return(double)

      sut = Trusona::Api::HTTPClient.new
      sut.post(@path, @params)
    end
  end

  describe 'DELETEing' do
    before do
      @path = '/api/v1/widgets'
      @params = { resource: { name: 'w-1000' } }
    end

    it 'should build a signed request' do
      # bad, mocking what we don't own
      allow(HTTParty).to receive(:delete)
      allow(Trusona::Api::VerifiedResponse).to receive(:new)

      # bad, should be injecting this dependency
      expect(Trusona::Api::SignedRequest).to receive(:new).with(
        @path,
        @params,
        'DELETE',
        'https://example.org'
      ).and_return(double(uri: '', body: '', headers: ''))

      sut = Trusona::Api::HTTPClient.new('https://example.org')
      sut.delete(@path, @params)
    end

    it 'should tell the http library to complete the request' do
      # bad, should be injecting this dependency
      allow(Trusona::Api::SignedRequest).to receive(:new).and_return(
        double(uri: 'uri', body: 'body', headers: 'headers')
      )

      allow(Trusona::Api::VerifiedResponse).to receive(:new)

      expect(HTTParty).to receive(:delete).with(
        'uri',
        body: 'body',
        headers: 'headers'
      )

      sut = Trusona::Api::HTTPClient.new
      sut.delete(@path, @params)
    end

    it 'should verify the response' do
      unverified = double
      allow(Trusona::Api::SignedRequest).to receive(:new).and_return(
        double(uri: 'uri', body: 'body', headers: 'headers')
      )

      allow(HTTParty).to receive(:delete).and_return(
        unverified
      )

      expect(Trusona::Api::VerifiedResponse).to receive(:new).with(unverified).and_return(double)

      sut = Trusona::Api::HTTPClient.new
      sut.delete(@path, @params)
    end
  end

end
# rubocop:enable Metrics/BlockLength
