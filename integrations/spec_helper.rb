# frozen_string_literal: true

require 'dotenv/load'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'bundler/setup'
require 'active_support/core_ext/numeric/time'
require 'rspec/wait'
require 'trusona'
require 'securerandom'
require 'webmock/rspec'
require_relative 'buster'

WebMock.allow_net_connect!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Trusona.config do |c|
  c.api_host       = ENV['TRUSONA_API_HOST']
  c.secret         = ENV['TRUSONA_SECRET']
  c.token          = ENV['TRUSONA_TOKEN']
end