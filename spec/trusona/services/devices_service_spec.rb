# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::DevicesService do
  it 'uses the correct collection path' do
    sut = Trusona::Services::DevicesService.new
    expect(sut.collection_path).to eq('/api/v2/devices')
  end
end
