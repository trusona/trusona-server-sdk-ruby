# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::UserAccount do
  describe 'building a user account resource for an API response' do
    before do
      @user_params = JSON(%({"trusona_id":"001682675","status":"active","first_name":"john","last_name":"public","nickname":"john.public","handle":"ead9d16a-1dcc-4183-ab1e-d05779da8a82","metadata":{"max_level":"essential","devices":["5ebb929e-719f-471b-98b2-27bca6babde4","09c273c5-f842-4dc4-ba8d-6e46331b8bd3"],"tokens":[],"roles":["tru-user"]},"email":"user@example.com","emails":[{"id":"6d2bc5b6-adb4-4a98-9fea-1e26e2371af9","email":"user@example.com","verified":true},{"id":"31640394-72bf-46e7-b433-d50b83d95c15","email":"user@example.org","verified":true}]}))

      @sut = Trusona::Resources::UserAccount.new(@user_params)
    end

    it 'should expose the trusona id' do
      expect(@sut.trusona_id).to eq('001682675')
    end

    it 'should expose the status' do
      expect(@sut.status).to eq(Trusona::Resources::UserAccount::Status::ACTIVE)
    end

    it 'should expose the first name' do
      expect(@sut.first_name).to eq('john')
    end

    it 'should expose the last name' do
      expect(@sut.last_name).to eq('public')
    end

    it 'should expose the nickname' do
      expect(@sut.nickname).to eq('john.public')
    end

    it 'should expose the handle' do
      expect(@sut.handle).to eq('ead9d16a-1dcc-4183-ab1e-d05779da8a82')
    end

    it 'should expose the primary email' do
      expect(@sut.email).to eq('user@example.com')
    end

    it 'should expose any additional emails' do
      expect(@sut.emails.map(&:email)).to(
        eq(['user@example.com', 'user@example.org'])
      )

      expect(@sut.emails.map(&:id)).to(
        eq(
          [
            '6d2bc5b6-adb4-4a98-9fea-1e26e2371af9',
            '31640394-72bf-46e7-b433-d50b83d95c15'
          ]
        )
      )
    end

    it 'should expose the max level of the user' do
      expect(@sut.max_level).to(
        eq(Trusona::Resources::UserAccount::Level::ESSENTIAL)
      )
    end

    context 'when the max level is unknown' do
      it 'the default of entry is used' do
        sut = Trusona::Resources::UserAccount.new(
          @user_params.merge('metadata' => { 'max_level' => nil })
        )

        expect(sut.max_level).to(
          eq(Trusona::Resources::UserAccount::Level::ENTRY)
        )
      end

      context 'because the user has no metadata' do
        it 'the default of entry is used' do
          sut = Trusona::Resources::UserAccount.new(
            @user_params.merge('metadata' => nil)
          )

          expect(sut.max_level).to(
            eq(Trusona::Resources::UserAccount::Level::ENTRY)
          )
        end
      end
    end

    context 'when the max level is executive' do
      it 'should correctly expose the max level' do
        sut = Trusona::Resources::UserAccount.new(
          @user_params.merge('metadata' => { 'max_level' => 'executive' })
        )

        expect(sut.max_level).to(
          eq(Trusona::Resources::UserAccount::Level::EXECUTIVE)
        )
      end
    end

    context 'when the max level is unrecognized' do
      it 'the default of entry is used' do
        sut = Trusona::Resources::UserAccount.new(
          @user_params.merge('metadata' => { 'max_level' => 'foobar' })
        )

        expect(sut.max_level).to(
          eq(Trusona::Resources::UserAccount::Level::ENTRY)
        )
      end
    end

    context 'when the status cannot be determined' do
      it 'should expose an unknown status' do
        sut = Trusona::Resources::UserAccount.new(
          @user_params.merge('status' => 'foobar')
        )

        expect(sut.status).to(
          eq(Trusona::Resources::UserAccount::Status::UNKNOWN)
        )
      end
    end

    context 'when the status is inactive' do
      it 'should correctly expose the status' do
        sut = Trusona::Resources::UserAccount.new(
          @user_params.merge('status' => 'inactive')
        )

        expect(sut.status).to(
          eq(Trusona::Resources::UserAccount::Status::INACTIVE)
        )
      end
    end
  end
end
