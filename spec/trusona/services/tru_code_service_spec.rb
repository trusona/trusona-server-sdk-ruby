# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::TruCodesService do
  before do
    Trusona.config do |c|
      c.secret = 'secret'
      c.token  = 'token'
      c.api_host = 'https://testing.local'
    end

    @valid_tru_code = Trusona::Resources::TruCode.new(
      relying_party_id: SecureRandom.uuid
    )

    @response = double(code: 201)
  end

  it 'should use the Trusona config api_host by default' do
    expect(Trusona::Api::HTTPClient).to receive(:new).with('testing.local')
    Trusona::Services::TruCodesService.new()
  end

  it 'should be configurable with a custom client' do
    Trusona::Services::TruCodesService.new(client: double)
  end

  it 'should be configurable with a custom mapper' do
    Trusona::Services::TruCodesService.new(mapper: double)
  end

  it 'should use a default client and mapper' do
    Trusona::Services::TruCodesService.new
  end

  describe 'creating a TruCode' do
    it 'should require a TruCode' do
      sut = Trusona::Services::TruCodesService.new(
        client: double(post: @response),
        mapper: Trusona::Mappers::NilMapper.new
      )
      sut.create(@valid_tru_code)
    end

    it 'should tell the client to POST the resource without a JSON body' do
      client_double = double(post: @response)
      sut = Trusona::Services::TruCodesService.new(
        client: client_double,
        mapper: Trusona::Mappers::NilMapper.new
      )
      expect(client_double).to receive(:post).with(
        '/api/v2/trucodes',
        @valid_tru_code.to_json
      )

      sut.create(@valid_tru_code)
    end
  end
end
