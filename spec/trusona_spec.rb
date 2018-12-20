# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona do
  it 'has a version number' do
    expect(Trusona::VERSION).not_to be nil
  end

  describe 'configuring' do
    it 'should have a configurable api secret' do
      Trusona.config do |c|
        c.secret = 'my secret'
      end

      expect(Trusona.config.secret).to eq 'my secret'
    end

    it 'should have a configurable api token' do
      Trusona.config do |c|
        c.token  = 'my token'
      end

      expect(Trusona.config.token).to eq 'my token'
    end

    it 'should have a configurable api host' do
      Trusona.config do |c|
        c.api_host  = 'https://example.com'
      end

      expect(Trusona.config.api_host).to eq 'example.com'
    end

    it 'should strip trailing slashes from the api host' do
      Trusona.config do |c|
        c.api_host  = 'https://example.com/'
      end

      expect(Trusona.config.api_host).to eq 'example.com'
    end

    it 'should have a default configuration' do
      Trusona.config { }

      expect(Trusona.config.secret).to be_nil
      expect(Trusona.config.token).to be_nil
      expect(Trusona.config.api_host).to eq('api.trusona.net')
    end
  end
end
