# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::User do

  describe 'attributes' do
    let (:params) { { user_identifier: 'abc' } }
    let (:sut) { Trusona::Resources::User.new(params) }

    it 'should have a user_identifier' do
      expect(sut.user_identifier).to eq(params[:user_identifier])
    end

    it 'should have an id' do
      expect(sut.id).to eq(params[:user_identifier])
    end
  end
end
