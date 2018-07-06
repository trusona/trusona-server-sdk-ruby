# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Trusona::Api::SignedRequest do
  before do
    Trusona.config do |c|
      c.api_host = 'https://example.com'
      c.secret = 'secret'
      c.token = 'token'
    end

    @path = '/api/v3/widgets'
    @body = JSON(resource: { id: 1234, name: 'widget' })
    @content_type = Trusona::Api::HTTPClient::CONTENT_TYPE
    @method = 'POST'
    @host = 'example.org'
  end

  describe 'creating a signed request' do
    it 'should require a path' do
      expect do
        Trusona::Api::SignedRequest.new(nil, @body, @method, @host)
      end.to raise_error(ArgumentError)
    end

    it 'should require a body' do
      expect do
        Trusona::Api::SignedRequest.new(@path, nil, @method, @host)
      end.to raise_error(ArgumentError)
    end

    it 'should require a method' do
      expect do
        Trusona::Api::SignedRequest.new(@path, @body, nil, @host)
      end.to raise_error(ArgumentError)
    end

    it 'should require a host' do
      expect do
        Trusona::Api::SignedRequest.new(@path, @body, @method, nil)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'when the body is not JSON' do
    before do
      path = '/api/v3/widgets'
      body = { id: 1234, name: 'widget' }
      method = 'GET'
      host = 'example.com'
      @sut = Trusona::Api::SignedRequest.new(path, body, method, host)
    end

    it 'should encode the body as query string parameters' do
      expected = URI('https://example.com/api/v3/widgets?id=1234&name=widget')

      expect(@sut.uri).to eq(expected)
      expect(@sut.body).to be_empty
    end

    it 'should send an empty body' do
      expect(@sut.body).to be_empty
    end
  end

  describe 'when the body is empty' do
    it 'should not encode the empty body as query string parameters' do
      path = '/api/v3/widgets'
      body = {}
      method = 'GET'
      host = 'example.com'

      sut = Trusona::Api::SignedRequest.new(path, body, method, host)
      expected = URI('https://example.com/api/v3/widgets')

      expect(sut.uri).to eq(expected)
      expect(sut.body).to be_empty
    end
  end

  describe 'when the request cannot be signed' do
    it 'should raise an error' do
      allow(Trusona::Api::HashedMessage).to receive(:new).and_raise(
        Trusona::SigningError
      )

      expect { Trusona::Api::SignedRequest.new(@path, @body, @method, @host) }.to(
        raise_error(Trusona::SigningError)
      )
    end
  end

  describe 'signing the request' do
    before do
      # this is bad
      @now = Time.now
      allow(Time).to receive(:now).and_return(@now)
    end

    it 'should use the supplied host' do
      sut = Trusona::Api::SignedRequest.new(
        '/api/v2/dogs',
        JSON(name: 'peggy'),
        'POST',
        'example.net'
      )

      expect(sut.uri.to_s).to eq('https://example.net/api/v2/dogs')
    end

    it 'should tell the hashed message to generate a signature' do
      # This is also bad, should be injected
      expect(Trusona::Api::HashedMessage).to receive(:new).with(
        body: @body,
        content_type: @content_type,
        path: @path,
        method: @method,
        date: @now.gmtime.httpdate.to_s
      ).and_call_original

      sut = Trusona::Api::SignedRequest.new(@path, @body, @method, @host)
      expect(sut.headers['Authorization']).to be
    end

    context 'when the body is in the query string' do
      it 'should include the query string in the path' do
        path = '/api/v3/widgets'
        body = { id: 1234, name: 'widget' }
        method = 'GET'
        host = 'example.com'

        expect(Trusona::Api::HashedMessage).to receive(:new).with(
          body: '',
          content_type: '',
          path: '/api/v3/widgets?id=1234&name=widget',
          method: 'GET',
          date: @now.gmtime.httpdate.to_s
        ).and_call_original

        Trusona::Api::SignedRequest.new(path, body, method, host)
      end
    end

    context 'when there is a query string and a JSON body' do
      it 'should include the query string in the path and the body in the body' do
        path = '/api/v3/widgets?active=1'
        body = JSON(id: 1234, name: 'widget')
        method = 'GET'
        host = 'example.com'

        expect(Trusona::Api::HashedMessage).to receive(:new).with(
          body: '{"id":1234,"name":"widget"}',
          content_type: '',
          path: '/api/v3/widgets?active=1',
          method: 'GET',
          date: @now.gmtime.httpdate.to_s
        ).and_call_original

        Trusona::Api::SignedRequest.new(path, body, method, host)
      end
    end
  end

  describe 'generating headers' do
    before do
      @sut = Trusona::Api::SignedRequest.new(@path, @body, @method, @host)
    end
    it 'should automatically generate a date header' do
      expect(@sut.headers).to include('Date')
      expect(@sut.headers).to include('X-Date')
      expect(@sut.headers).to include('x-date')
    end

    it 'should automatically generate an authorization header' do
      expect(@sut.headers).to include('Authorization')
    end

    context 'when performing a GET request' do
      it 'should automatically add a blank content-type header' do
        @sut = Trusona::Api::SignedRequest.new(@path, @body, 'GET', @host)
        expect(@sut.headers).to include('Content-Type')
        expect(@sut.headers['Content-Type']).to eq('')
      end
    end

    context 'when performing a POST request' do
      it 'should automatically add a content-type header' do
        @sut = Trusona::Api::SignedRequest.new(@path, @body, 'POST', @host)
        expect(@sut.headers).to include('Content-Type')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
