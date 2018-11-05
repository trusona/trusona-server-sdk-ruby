# frozen_string_literal:true

require 'spec_helper'
require 'tempfile'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'TruCodes' do
  before do
    Trusona.config do |c|
      c.tru_codes_host = ENV['TRU_CODES_HOST']
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

    xdescribe 'and when you want to check the status of that TruCode' do
      before do
        @qr = Tempfile.new('tru_code')
        code = Trusona::Resources::TruCode.new(
          reference_id: @reference_id,
          action: 'verify',
          resource: 'integration-test',
          level: 1
        )

        @created = Trusona::TruCode.create(code)
      end

      after do
        @qr.close
        @qr.unlink
      end

      it 'can be checked by using the tru code resource' do
        expect { Trusona::TruCode.status(@created) }.to(
          raise_error(Trusona::ResourceNotFoundError)
        )
      end

      it 'can be checked by using the tru_code resource' do
        expect { Trusona::TruCode.status(@created.tru_code) }.to(
          raise_error(Trusona::ResourceNotFoundError)
        )
      end

      it 'can be checked by using the tru_code id' do
        expect { Trusona::TruCode.status(tru_code_id: @created.tru_code.id) }.to(
          raise_error(Trusona::ResourceNotFoundError)
        )
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
