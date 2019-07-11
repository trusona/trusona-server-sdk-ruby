# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::TrusonaficationCreator do
  before do
    @passthrough_service = double(
      Trusona::Services::TrusonaficationService,
      create: double(status: 'IN_PROGRESS'),
      get: double(status: 'ACCEPTED')
    )

    @valid_params = {
      user_identifier: 'u-1',
      action: 'login',
      resource: 'account',
      level: 1
    }
  end
  describe 'creating a trusonafication creator worker' do
    it 'optionally accepts a service' do
      Trusona::Workers::TrusonaficationCreator.new(service: double)
    end

    it 'uses a default service' do
      expect(Trusona::Services::TrusonaficationService).to(
        receive(:new)
      ).and_return(double)

      Trusona::Workers::TrusonaficationCreator.new
    end
  end

  describe 'creating trusonafications' do
    before do
      @sut = Trusona::Workers::TrusonaficationCreator.new(
        service: @passthrough_service
      )
    end

    it 'requires a list of parameters' do
      expect { @sut.create }.to raise_error(ArgumentError)
      expect { @sut.create(params: @valid_params) }.to_not raise_error
    end

    it 'builds a Trusonafication resource with the provided parameters' do
      expect(Trusona::Resources::Trusonafication).to(
        receive(:new)
      ).with(@valid_params)

      @sut.create(params: @valid_params)
    end

    it 'builds a Trusonafication resource with the provided parameters including custom fields' do
      data = @valid_params.merge(custom_field: {african:'tiger', taco:'bell'})

      expect(Trusona::Resources::Trusonafication).to(
        receive(:new)
      ).with(data)

      @sut.create(params: data)
    end

    it 'tells the service to create the resource' do
      spy = double(Trusona::Resources::Trusonafication)
      allow(Trusona::Resources::Trusonafication).to(
        receive(:new)
      ).with(@valid_params).and_return(spy)

      expect(@passthrough_service).to(receive(:create)).with(spy)

      @sut.create(params: @valid_params)
    end

    context 'using a blocking strategy' do
      it 'optionally accepts a timeout' do
        @sut.create(params: @valid_params, timeout: 10)
      end
      it 'uses a default timeout' do
        @sut.create(params: @valid_params) do |truso|
        end
      end
    end

    context 'using an async strategy' do
      it 'automatically gets the status of the trusonafication' do
        in_progress_dummy = double(
          status: 'IN_PROGRESS',
          resource: 'website',
          action: 'login',
          level: 1,
          id: '1234'
        )

        completed_dummy = double(
          status: 'ACCEPTED',
          resource: 'website',
          action: 'login',
          level: 1,
          id: '1234'
        )

        stubbed_service = double(get: double, create: in_progress_dummy)

        sut = Trusona::Workers::TrusonaficationCreator.new(
          service: stubbed_service
        )

        # first time, return the same as create
        allow(stubbed_service).to receive(:get).once.and_return(
          in_progress_dummy
        )

        # second time, return the 'updated' trusonafication
        allow(stubbed_service).to receive(:get).once.and_return(completed_dummy)

        result = nil
        sut.create(params: @valid_params, timeout: 1) do |trusonafication|
          result = trusonafication
        end

        expect(result.resource).to eq completed_dummy.resource
        expect(result.action).to eq completed_dummy.action
        expect(result.level).to eq completed_dummy.level

        expect(result.status).to eq completed_dummy.status
        expect(result.id).to be
      end
    end
  end
end
