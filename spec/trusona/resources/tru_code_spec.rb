# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Resources::TruCode do
  before do
    Trusona.config do |c|
      c.token = 'first.eyJzdWIiOiIwZjAzNDhmMC00NmQ2LTQ3YzktYmE0ZC0yZTdjZDdmODJlM2UiLCJuYmYiOjE1MTU1MzQ1MDIsImF0aCI6IlJPTEVfVFJVU1RFRF9SUCIsImlzcyI6InRzOjlmOGY1OTIwLWFjNGEtNDE1Zi1hODEwLWIzN2Y5Njk5M2JkZiIsImV4cCI6MTU0NzA3MDUwMiwiaWF0IjoxNTE1NTM0NTAyLCJqdGkiOiIxNDk3MzUyNC1kMzM2LTQ3NGYtODFkYS1hNmRjNzY5NDdjYmYifQ.third'
    end

    @valid_params = {
      id: SecureRandom.uuid,
      relying_party_id: SecureRandom.uuid,
      payload: 'payload'
    }
  end

  describe 'using the TruCode with the Trusona API' do
    it 'can represent itself as JSON' do
      sut = Trusona::Resources::TruCode.new(@valid_params)
      expect(sut.to_json).to eq(JSON(@valid_params))
    end

    context 'when a relying party is present' do
      it 'should be included in the JSON' do
        with_relying_party = @valid_params.merge(relying_party_id: 'rp-123')
        sut = Trusona::Resources::TruCode.new(with_relying_party)
        expect(sut.to_json).to eq(JSON(with_relying_party))
      end
    end
  end

  describe 'creating a new TruCode' do
    context 'when the required parameters are present and not empty' do
      it 'the TruCode should be successfully instantiated' do
        expect { Trusona::Resources::TruCode.new(@valid_params) }.not_to(
          raise_error
        )
      end

      it 'the TruCode should know that it is valid' do
        sut = Trusona::Resources::TruCode.new(@valid_params)
        expect(sut.valid?).to be_truthy
      end
    end

    it 'uses the relying party id from the configured API token' do
      expect do
        Trusona::Resources::TruCode.new(
          @valid_params.merge!(relying_party_id: nil)
        )
      end.to_not raise_error
    end
  end
end
