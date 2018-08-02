# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::UsersService do
  it 'uses the correct collection path' do
    sut = Trusona::Services::UsersService.new
    expect(sut.collection_path).to eq('/api/v2/users')
  end
end
