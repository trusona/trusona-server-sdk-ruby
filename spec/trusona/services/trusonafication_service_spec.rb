# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::TrusonaficationService do
  it 'uses the correct collection path' do
    sut = Trusona::Services::TrusonaficationService.new
    expect(sut.collection_path).to eq('/api/v2/trusonafications')
  end
end
