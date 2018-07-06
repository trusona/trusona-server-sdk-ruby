# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::UserIdentifiersService do
  it 'uses the correct collection path' do
    sut = Trusona::Services::UserIdentifiersService.new
    expect(sut.collection_path).to eq('/api/v2/user_identifiers')
  end
end
