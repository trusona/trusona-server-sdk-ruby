# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Trusona::Api::VerifiedResponse do
  before do
    Trusona.config do |c|
      c.api_host = 'https://example.com'
      c.secret = 'secret'
      c.token = 'token'
    end

    @date = Time.now.gmtime.httpdate
    @content_type = Trusona::Api::HTTPClient::CONTENT_TYPE
    @request_content_type = 'request-content-type'

    @unverified = double(
      HTTParty::Response,
      body: JSON(widget: { id: 1, name: 'w-1000' }),
      code: 200,
      request: double(
        http_method: Net::HTTP::Get,
        options: {
          headers: {
            'Content-Type' => @request_content_type
          }
        },
        uri: URI::HTTPS.build(
          host: Trusona.config.api_host,
          path: '/api/v1/widgets/1',
          query: 'filter=true'
        )
      ),
      headers: {
        'X-Signature' => 'signature',
        'Content-Type' => @content_type,
        'Date' => @date
      }
    )
  end

  it 'should use the unverified response\'s status code' do
    sut = Trusona::Api::VerifiedResponse.new(@unverified)
    expect(sut.code).to eq(200)
  end

  describe 'as a hash' do
    it 'should represent the original response body as a hash' do
      sut = Trusona::Api::VerifiedResponse.new(@unverified)
      expect(sut.to_h).to eq(JSON.parse(@unverified.body))
    end
  end

  describe 'verifying api responses' do
    it 'should accept a response' do
      Trusona::Api::VerifiedResponse.new(@unverified)
    end

    context 'when the server is using the legacy HMAC format' do
      it 'should verify the HMAC signature with the request\'s content type' do
        legacy_response = @unverified
        legacy_response.headers['server'] = 'Apache-Coyote/1.1'
        expect(Trusona::Api::HashedMessage).to receive(:new).with(
          method: 'GET',
          body: legacy_response.body,
          content_type: @request_content_type,
          path: '/api/v1/widgets/1?filter=true',
          date: @date
        ).and_return(double(signature: 'signature'))

        Trusona::Api::VerifiedResponse.new(legacy_response)
      end
    end

    context 'when the server is using the current HMAC format' do
    end

    it 'should use the response to generate a message signature' do
      stubbed_hashed_message = double(signature: 'signature')

      expect(Trusona::Api::HashedMessage).to receive(:new).with(
        method: 'GET',
        body: @unverified.body,
        content_type: @content_type,
        path: '/api/v1/widgets/1?filter=true',
        date: @date
      ).and_return(stubbed_hashed_message)

      sut = Trusona::Api::VerifiedResponse.new(@unverified)
      expect(sut.verified?).to be_truthy
    end

    it 'should check the base64 decoded version as well' do
      stubbed_hashed_message = double(signature: 'not the signature')

      expect(Base64).to receive(:strict_decode64).with('not the signature').and_return('signature')

      expect(Trusona::Api::HashedMessage).to receive(:new).with(
        method: 'GET',
        body: @unverified.body,
        content_type: @content_type,
        path: '/api/v1/widgets/1?filter=true',
        date: @date
      ).and_return(stubbed_hashed_message)

      sut = Trusona::Api::VerifiedResponse.new(@unverified)
      expect(sut.verified?).to be_truthy
    end

    context 'when the response cannot be verified' do
      it 'should raise an error' do
        @date = Time.now.gmtime.httpdate
        allow(Trusona::Api::HashedMessage).to receive(:new).and_raise(ArgumentError)

        expect { Trusona::Api::VerifiedResponse.new(@unverified) }.to(
          raise_error(Trusona::SigningError)
        )
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
