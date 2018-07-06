# frozen_string_literal: true

require 'spec_helper'
require 'date'

RSpec.describe Trusona::Resources::Trusonafication do
  before do
    @valid_params = {
      action:                 'verify',
      created_at:             '2018-03-30T21:08:44.233Z',
      desired_level:          2,
      expires_at:             '2018-03-30T21:10:44.184Z',
      id:                     'c52e1b3c-caf2-4361-8ec4-141964eb548e',
      prompt:                 true,
      relying_party:          'The Human Fund, Inc.',
      resource:               'integration test suite',
      show_identity_document: false,
      status:                 'IN_PROGRESS',
      updated_at:             '2018-03-30T21:08:44.233Z',
      user_identifier:        'claytonhauz@gmail.com',
      device_identifier:      '16B52319-AD81-4AE8-AE40-14F4C3292947',
      trucode_id:             '2A99A895-A8A3-4C89-A087-06D6EBEE1E4F',
      trusona_id:             '123456789',
      user_presence:          true,
      level:                  2,
      result: {
        accepted_level: 2
      }
    }
  end

  describe 'trusonafication acceptance status' do
    context 'when the trusonafication was rejected' do
      it 'should be considered a rejected trusonafication' do
        sut = Trusona::Resources::Trusonafication.new(status: 'REJECTED')
        expect(sut.accepted?).to_not be
        expect(sut.rejected?).to be
      end
    end

    context 'when the trusonafication was accepted at the requested level' do
      it 'should be considered an accepted trusonafication' do
        sut = Trusona::Resources::Trusonafication.new(status: 'ACCEPTED')
        expect(sut.accepted?).to be
        expect(sut.rejected?).to_not be
      end
    end

    context 'when the trusonafication was accepted at a higher level than requested' do
      it 'should be considered an accepted trusonafication' do
        sut = Trusona::Resources::Trusonafication.new(status: 'ACCEPTED_AT_HIGHER_LEVEL')
        expect(sut.accepted?).to be
        expect(sut.rejected?).to_not be
      end
    end

    context 'when the trusonafication was accepted at a lower level than requested' do
      it 'should be considered a rejected trusonafication' do
        sut = Trusona::Resources::Trusonafication.new(status: 'ACCEPTED_AT_LOWER_LEVEL')
        expect(sut.accepted?).to_not be
        expect(sut.rejected?).to be
      end
    end
  end

  describe 'trusonafication status' do
    context 'when the server status is empty' do
      it 'should be invalid' do
        sut = Trusona::Resources::Trusonafication.new(status: nil)

        expect(sut.status).to eq(:invalid)
      end
    end

    context 'when the status from the server is INVALID' do
      it 'should be invalid' do
        sut = Trusona::Resources::Trusonafication.new(status: 'INVALID')

        expect(sut.status).to eq(:invalid)
      end
    end

    context 'when the status from the server is INVALID_TRUSONA_ID' do
      it 'should have a status of invalid trusona id' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'INVALID_TRUSONA_ID')
        )

        expect(sut.status).to eq(:invalid_trusona_id)
      end
    end

    context 'when the status from the server is IN_PROGRESS' do
      it 'should be in progress' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'IN_PROGRESS')
        )

        expect(sut.status).to eq(:in_progress)
      end
    end

    context 'when the status from the server is REJECTED' do
      it 'should be rejected' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'REJECTED')
        )

        expect(sut.status).to eq(:rejected)
      end
    end

    context 'when the status from the server is ACCEPTED' do
      it 'should be accepted' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'ACCEPTED')
        )

        expect(sut.status).to eq(:accepted)
      end
    end

    context 'when the status from the server is INVALID_EMAIL' do
      it 'should have a status of invalid email' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'INVALID_EMAIL')
        )

        expect(sut.status).to eq(:invalid_email)
      end
    end

    context 'when the status from the server is ACCEPTED_AT_LOWER_LEVEL' do
      it 'should be accepted, but at a lower level' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'ACCEPTED_AT_LOWER_LEVEL')
        )

        expect(sut.status).to eq(:accepted_at_lower_level)
      end
    end

    context 'when the status from the server is ACCEPTED_AT_HIGHER_LEVEL' do
      it 'should accepted, but at a higher level' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'ACCEPTED_AT_HIGHER_LEVEL')
        )

        expect(sut.status).to eq(:accepted_at_higher_level)
      end
    end

    context 'when the status from the server is EXPIRED' do
      it 'should be expired' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(status: 'EXPIRED')
        )

        expect(sut.status).to eq(:expired)
      end
    end
  end

  describe 'specifying an expiration date' do
    context 'when the expires_at value is a Time object' do
      it 'should force the specified time to utc' do
        pst_time = Time.now.localtime('-07:00')
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(expires_at: pst_time)
        )

        expect(sut.expires_at).to eq(pst_time.gmtime)
      end
    end
    context 'when the expires_at value is a DateTime object' do
      it 'should force the specified date time to utc' do
        pst_time = DateTime.now
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(expires_at: pst_time)
        )

        expect(sut.expires_at).to eq(pst_time.to_time.gmtime)
      end
    end

    context 'when the expires_at value is a String' do
      it 'should be parsed into a DateTime instance' do
        string_time = DateTime.now.to_s
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(expires_at: string_time)
        )

        expect(sut.expires_at).to be_a(Time)
      end

      it 'should be made to be utc' do
        string_time = DateTime.now.to_s
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(expires_at: string_time)
        )

        expect(sut.expires_at).to(
          eq(DateTime.parse(string_time).to_time.gmtime)
        )
      end
    end

    context 'when the expires_at value is a Date object' do
      it 'should ignore the specified date without a time component' do
        pst_time = Date.today
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge(expires_at: pst_time)
        )

        expect(sut.expires_at).to be_nil
      end
    end
  end

  describe 'setting the prompt value' do
    context 'when not present' do
      it 'defaults to being true' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge!(prompt: nil)
        )
        expect(sut.prompt).to be true
      end
    end

    context 'when present' do
      it 'assumes the value specified' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge!(prompt: false)
        )
        expect(sut.prompt).to be false
      end
    end
  end

  describe 'setting the user presence value' do
    context 'when not present' do
      it 'defaults to being true' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge!(user_presence: nil)
        )
        expect(sut.user_presence).to be true
      end
    end

    context 'when present' do
      it 'assumes the value specified' do
        sut = Trusona::Resources::Trusonafication.new(
          @valid_params.merge!(user_presence: false)
        )
        expect(sut.user_presence).to be false
      end
    end
  end

  describe 'as JSON' do
    before do
      @iso8601 = DateTime.parse(@valid_params[:expires_at])
                         .to_time.gmtime.iso8601
      @json = Trusona::Resources::Trusonafication.new(@valid_params).to_json
    end

    it 'should contain the expiration date as ISO8601' do
      expected = DateTime.parse(@valid_params[:expires_at].to_s)
                         .to_time.gmtime.iso8601
      expect(JSON.parse(@json)['expires_at']).to eq(expected)
    end

    it 'should contain the trucode id' do
      expect(JSON.parse(@json)['trucode_id']).to eq(@valid_params[:trucode_id])
    end

    it 'can serialize a trusonafication with a nil expires at' do
      @json = Trusona::Resources::Trusonafication.new(@valid_params.merge(expires_at: nil)).to_json
      expect(JSON.parse(@json)['expires_at']).to eq(nil)
    end
  end

  describe 'exposing parameters of the resource' do
    before do
      @sut = Trusona::Resources::Trusonafication.new(@valid_params)
    end
    it 'should return the properties of the resource' do
      expect(@sut.device_identifier).to eq(@valid_params[:device_identifier])
      expect(@sut.user_identifier).to eq(@valid_params[:user_identifier])
      expect(@sut.resource).to eq(@valid_params[:resource])
      expect(@sut.action).to eq(@valid_params[:action])
      expect(@sut.level).to eq(@valid_params[:level])
      expect(@sut.callback_url).to eq(@valid_params[:callback_url])
      expect(@sut.expires_at).to_not be_nil

      expect(@sut.to_h).to eq(@valid_params)
    end

    it 'should have a device identifier' do
      expect(@sut.device_identifier).to eq(@valid_params[:device_identifier])
    end

    it 'should have a user identifier' do
      expect(@sut.user_identifier).to eq(@valid_params[:user_identifier])
    end

    it 'should have a trucode id' do
      expect(@sut.trucode_id).to eq(@valid_params[:trucode_id])
    end

    it 'should have a trusona id' do
      expect(@sut.trusona_id).to eq(@valid_params[:trusona_id])
    end

    it 'should have a resource' do
      expect(@sut.resource).to eq(@valid_params[:resource])
    end

    it 'should have an action' do
      expect(@sut.action).to eq(@valid_params[:action])
    end

    it 'should have a requested level' do
      expect(@sut.level).to eq(@valid_params[:level])
    end

    it 'should have an accepted level' do
      expect(@sut.accepted_level).to eq(@valid_params[:result][:accepted_level])
    end

    it 'should have a trusona id' do
      expect(@sut.trusona_id).to eq(@valid_params[:trusona_id])
    end

    it 'should have an expiration time' do
      expect(@sut.expires_at).to_not be_nil
    end
  end

  describe 'validating a trusonafication' do
    context 'when all required parameters are present' do
      it 'should be valid' do
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_truthy
      end
    end

    context 'when there is no resource' do
      it 'should not be valid' do
        @valid_params.delete(:resource)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when the resource is empty' do
      it 'should not be valid' do
        @valid_params.update(resource: '')
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when there is no action' do
      it 'should not be valid' do
        @valid_params.delete(:action)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when the action is empty' do
      it 'should not be valid' do
        @valid_params.update(action: '')
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when there is no level' do
      it 'should not be valid' do
        @valid_params.delete(:level)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when the identifier is empty' do
      it 'should not be valid' do
        @valid_params.update(device_identifier: '')
        @valid_params.update(user_identifier: '')
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when there is no identifier' do
      it 'should not be valid' do
        @valid_params.delete(:device_identifier)
        @valid_params.delete(:user_identifier)
        @valid_params.delete(:trucode_id)
        @valid_params.delete(:trusona_id)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_falsey
      end
    end

    context 'when there is only a device identifier' do
      it 'should be valid' do
        @valid_params.delete(:user_identifier)
        @valid_params.delete(:trucode_id)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_truthy
      end
    end

    context 'when there is only a user identifier' do
      it 'should be valid' do
        @valid_params.delete(:device_identifier)
        @valid_params.delete(:trucode_id)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_truthy
      end
    end

    context 'when there is only a trucode id' do
      it 'should be valid' do
        @valid_params.delete(:device_identifier)
        @valid_params.delete(:user_identifier)
        sut = Trusona::Resources::Trusonafication.new(@valid_params)
        expect(sut.valid?).to be_truthy
      end
    end
  end
end
