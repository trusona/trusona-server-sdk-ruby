# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona do
  it 'has a version number' do
    expect(Trusona::VERSION).not_to be nil
  end

  describe 'configuring' do
    after(:each) do
      Trusona.config do |c|
        c.secret   = nil
        c.token    = nil
        c.api_host = nil
        c.tru_codes_host = nil
      end
    end
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

    it 'should have a configurable tru_codes host' do
      Trusona.config do |c|
        c.tru_codes_host  = 'https://tru_codes.example.com'
      end

      expect(Trusona.config.tru_codes_host).to eq 'tru_codes.example.com'
    end

    it 'should strip trailing slashes from the tru_codes host' do
      Trusona.config do |c|
        c.tru_codes_host  = 'https://tru_codes.example.com/'
      end

      expect(Trusona.config.tru_codes_host).to eq 'tru_codes.example.com'
    end

    it 'should have a default configuration' do
      expect(Trusona.config.secret).to be_nil
      expect(Trusona.config.token).to be_nil
      expect(Trusona.config.api_host).to_not be_nil
      expect(Trusona.config.tru_codes_host).to_not be_nil
    end
  end
end
