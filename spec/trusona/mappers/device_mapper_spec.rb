# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::DeviceMapper do
  it 'should map to a device resource' do
    sut = Trusona::Mappers::DeviceMapper.new
    mapped = sut.map({ active: false })

    expect(mapped).to(be_a(Trusona::Resources::Device))
    expect(mapped.active).to(eq(false))
  end
end
