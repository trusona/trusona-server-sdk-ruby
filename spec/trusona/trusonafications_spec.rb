# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Trusona::Trusonafication do
  before do
    @valid_params = {
      user_identifier: 'u-1',
      action: 'login',
      resource: 'account'
    }

    @creation_params = @valid_params
  end

  describe 'finding a trusonafication' do
    before do
      allow(Trusona::Workers::TrusonaficationFinder).to(
        receive(:new)
      ).and_return(double(find: double))
    end

    it 'requires a trusonafication id' do
      expect { Trusona::Trusonafication.find(nil) }.to(
        raise_error(Trusona::InvalidRecordIdentifier)
      )

      expect { Trusona::Trusonafication.find('') }.to(
        raise_error(Trusona::InvalidRecordIdentifier)
      )

      expect do
        Trusona::Trusonafication.find('1234')
      end.to_not(raise_error)
    end

    it 'tells the worker to find the trusonafication' do
      stub = double(Trusona::Workers::TrusonaficationFinder)

      allow(Trusona::Workers::TrusonaficationFinder).to(
        receive(:new)
      ).and_return(stub)

      expect(stub).to(receive(:find)).with('1234')

      Trusona::Trusonafication.find('1234')
    end
  end

  describe 'creating a trusonafication' do
    before do
      allow(Trusona::Workers::TrusonaficationCreator).to(
        receive(:new)
      ).and_return(double(create: double))
    end

    it 'allows for optional custom_fields' do
      expect do
        Trusona::Trusonafication.create(params: @valid_params.merge(
          custom_fields: {african: 'tiger', taco: 'bell'}
        )
      )end.to_not(raise_error)

      expect do
        Trusona::Trusonafication.create(params: @valid_params
      )end.to_not(raise_error)
    end

    it 'requires a way to identify the user' do
      expect { Trusona::Trusonafication.create(params: {}) }.to(
        raise_error(ArgumentError)
      )

      expect do
        Trusona::Trusonafication.create(params: @valid_params)
      end.to_not(raise_error)

      device_id_params = @valid_params.merge(
        user_identifier: nil, device_identifier: 'd-1'
      )

      expect do
        Trusona::Trusonafication.create(params: device_id_params)
      end.to_not(raise_error)

      trucode_id_params = @valid_params.merge(
        user_identifier: nil, trucode_id: 't-1000'
      )

      expect do
        Trusona::Trusonafication.create(params: trucode_id_params)
      end.to_not(raise_error)

      trusona_id_params = @valid_params.merge(
        user_identifier: nil, trusona_id: 't-1000'
      )

      expect do
        Trusona::Trusonafication.create(params: trusona_id_params)
      end.to_not(raise_error)
    end

    it 'requires an action' do
      expect do
        Trusona::Trusonafication.create(
          params: @valid_params.merge(action: nil)
        )
      end.to(raise_error(ArgumentError))

      expect do
        Trusona::Trusonafication.create(
          params: @valid_params
        )
      end.to_not(raise_error)
    end

    it 'requires a resource' do
      expect do
        Trusona::Trusonafication.create(
          params: @valid_params.merge(resource: nil)
        )
      end.to(raise_error(ArgumentError))

      expect do
        Trusona::Trusonafication.create(
          params: @valid_params
        )
      end.to_not(raise_error)
    end

    it 'defaults to essential level trusonafications' do
      stub = double(Trusona::Workers::TrusonaficationCreator)
      allow(Trusona::Workers::TrusonaficationCreator).to(
        receive(:new).and_return(stub)
      )

      expect(stub).to receive(:create).with(
        params: @creation_params,
        timeout: nil
      )

      Trusona::Trusonafication.create(params: @valid_params)
    end

    context 'that is essential' do
      before do
        @spy_creator = double(Trusona::Workers::TrusonaficationCreator)
        allow(Trusona::Workers::TrusonaficationCreator).to(
          receive(:new).and_return(@spy_creator)
        )
      end
      it 'has delightful syntactic sugar for essential level trusonafications' do
        expect(@spy_creator).to(
          receive(:create).with(
            params: @valid_params.merge!(level: 2),
            timeout: nil
          )
        )

        Trusona::EssentialTrusonafication.create(params: @valid_params)
      end

      it 'should set the level to 2 when user presence is true' do
        expect(@spy_creator).to(
          receive(:create).with(
            params: {
              user_identifier: 'u-1',
              action: 'login',
              resource: 'account',
              level: 2,
              user_presence: true
            },
            timeout: nil
          )
        )

        Trusona::EssentialTrusonafication.create(params: {
          user_identifier: 'u-1',
          action: 'login',
          resource: 'account',
          user_presence: true
        })
      end

      it 'should set the level to 1 when user presence is false' do
        expect(@spy_creator).to(
          receive(:create).with(
            params: {
              user_identifier: 'u-1',
              action: 'login',
              resource: 'account',
              level: 1,
              user_presence: false
            },
            timeout: nil
          )
        )

        Trusona::EssentialTrusonafication.create(params: {
          user_identifier: 'u-1',
          action: 'login',
          resource: 'account',
          user_presence: false
        })
      end
    end

    context 'that is executive' do
      before do
        @spy_creator = double(Trusona::Workers::TrusonaficationCreator)
        allow(Trusona::Workers::TrusonaficationCreator).to(
          receive(:new).and_return(@spy_creator)
        )
      end
      it 'has delightful syntactic sugar for essential level trusonafications' do
        expect(@spy_creator).to(
          receive(:create).with(
            params: @valid_params.merge!(level: 3),
            timeout: nil
          )
        )

        Trusona::ExecutiveTrusonafication.create(params: @valid_params)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
