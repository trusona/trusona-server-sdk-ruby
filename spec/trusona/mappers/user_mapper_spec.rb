# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Mappers::UserMapper do
  it 'should map to a user resource' do
    sut = Trusona::Mappers::UserMapper.new
    mapped = sut.map({ user_identifier: 'taco' })

    expect(mapped).to(be_a(Trusona::Resources::User))
    expect(mapped.user_identifier).to(eq('taco'))
  end
end
