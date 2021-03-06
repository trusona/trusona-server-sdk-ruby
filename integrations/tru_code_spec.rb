# frozen_string_literal:true

require_relative 'spec_helper'
require 'tempfile'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'TruCodes' do
  before do
    Trusona.config do |c|
      c.api_host       = ENV['TRUSONA_API_HOST']
      c.secret         = ENV['TRUSONA_SECRET']
      c.token          = ENV['TRUSONA_TOKEN']
    end
  end
  
  describe 'creating a TruCode to show on your website' do
    before do
      @reference_id = SecureRandom.uuid
    end
    it 'just works' do
      code = Trusona::Resources::TruCode.new(
        reference_id: @reference_id,
        action: 'verify',
        resource: 'integration-test',
        level: 1
      )

      result = Trusona::TruCode.create(code)

      expect(result.relying_party_id).to be
      expect(result.id).to be
      expect(result.payload).to be
    end
  end
end
# rubocop:enable Metrics/BlockLength
