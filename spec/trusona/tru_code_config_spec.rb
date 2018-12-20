# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::TruCodeConfig do
  describe 'extracting the relying party id' do
    context 'when the token is correctly configured and valid' do
      it 'exposes the relying party from the configured API token' do
        Trusona.config do |c|
          c.token = 'first.eyJzdWIiOiIwZjAzNDhmMC00NmQ2LTQ3YzktYmE0ZC0yZTdjZDdmODJlM2UiLCJuYmYiOjE1MTU1MzQ1MDIsImF0aCI6IlJPTEVfVFJVU1RFRF9SUCIsImlzcyI6InRzOjlmOGY1OTIwLWFjNGEtNDE1Zi1hODEwLWIzN2Y5Njk5M2JkZiIsImV4cCI6MTU0NzA3MDUwMiwiaWF0IjoxNTE1NTM0NTAyLCJqdGkiOiIxNDk3MzUyNC1kMzM2LTQ3NGYtODFkYS1hNmRjNzY5NDdjYmYifQ.third'
        end

        sut = Trusona::TruCodeConfig.new
        expect(sut.relying_party_id).to eq('0f0348f0-46d6-47c9-ba4d-2e7cd7f82e3e')
      end
    end
    context 'when the token is not configured' do
      it 'should raise an error' do
        Trusona.config do |c|
          c.token = nil
        end

        expect { Trusona::TruCodeConfig.new.relying_party_id }.to(
          raise_error(Trusona::ConfigurationError, 'API Token is missing.')
        )
      end
    end

    context 'when the token is not a valid JWT' do
      it 'should raise an error' do
        Trusona.config do |c|
          c.token = 'foo-bar-baz'
        end

        expect { Trusona::TruCodeConfig.new.relying_party_id }.to(
          raise_error(Trusona::ConfigurationError, 'API Token is missing.')
        )
      end
    end

    context 'when the token is not valid JSON' do
      it 'should raise an error' do
        Trusona.config do |c|
          c.token = 'foo.baz.bar'
        end

        expect { Trusona::TruCodeConfig.new.relying_party_id }.to(
          raise_error(Trusona::ConfigurationError, 'JWT Format is Invalid.')
        )
      end
    end

    context 'when the token is missing the subject' do
      it 'should raise an error' do
        Trusona.config do |c|
          c.token = 'foo.eyJmb28iOiAiYmFyIn0=.bar'
        end

        expect { Trusona::TruCodeConfig.new.relying_party_id }.to(
          raise_error(Trusona::ConfigurationError, 'Subject is Missing.')
        )
      end
    end
  end
end
