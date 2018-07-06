# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::IdentityDocumentMapper do
  it 'should properly map the hash attribute' do
    @response = {
      hash: 'b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c',
      id: '12345',
      type: 'AAMVA_DRIVERS_LICENSE',
      verification_status: 'UNVERIFIED'
    }

    sut = Trusona::Mappers::IdentityDocumentMapper.new
    result = sut.map(@response)

    expect(result.document_hash).to(eq(@response[:hash]))
  end
end
