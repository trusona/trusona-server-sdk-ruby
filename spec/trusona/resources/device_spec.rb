# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::Device do

  describe 'as json' do
    it 'should use the available parameters' do
      params = { active: true, activated_at: '2018-03-30T21:10:44.184Z' }
      sut = Trusona::Resources::Device.new(params)

      expect(sut.to_json).to(
        eq(JSON(active: true, activated_at: '2018-03-30T21:10:44.184Z'))
      )
    end
  end

  describe 'attributes' do
    let (:params) { { id: 'abc', active: true, activated_at: '2018-03-30T21:10:44.184Z' } }
    let (:sut) { Trusona::Resources::Device.new(params) }

    it 'should have an active flag' do
      expect(sut.active).to eq(true)
    end

    it 'should have an activated_at time in UTC' do
      expect(sut.activated_at).to eq(DateTime.parse(params[:activated_at]).to_time.gmtime)
    end

    it 'should have an id' do
      expect(sut.id).to eq 'abc'
    end
  end
end
