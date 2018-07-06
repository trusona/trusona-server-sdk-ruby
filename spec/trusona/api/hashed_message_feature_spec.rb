# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Message Hashing' do
  before do
    @token = 'token'

    secret = '7f1dd753b6fa473d07c99b56d43bd5da3cd928487d5022e1810fab96c70945b01ad2603585542d33a1383b1f14b5880373474ff40c76a38df19052cefeb3a3eb'

    Trusona.config do |c|
      c.api_host = 'testing.local'
      c.token = @token
      c.secret = secret
    end
  end

  it 'should hash the message correctly' do
    expected = "TRUSONA #{@token}:YTgwNDgzNGRjNTA0YjBkYWJmNmFlMzU0MjJiNmRmYTRjNjk5NTQxMDk3MGFkN2YzZjlmZTYyMjdlMTlkNjc4Zg=="

    body = ''
    content_type = 'application/json'
    method = 'GET'
    path = '/test/auth?blah=blah'
    date = 'Tue, 27 Jun 2017 18:03:47 GMT'

    sut = Trusona::Api::HashedMessage.new(method: method,
                                          body: body,
                                          content_type: content_type,
                                          path: path,
                                          date: date)

    expect(sut.auth_header).to eq(expected)
  end
end
