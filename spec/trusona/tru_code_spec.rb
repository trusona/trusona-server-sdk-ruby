# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Trusona::TruCode do
  describe 'enabling a magic login experience' do
    describe 'by retriving an existing TruCode' do
      it 'requires a Trucode ID' do
        worker = double(find: double)
        id = '1'
        allow(Trusona::Workers::TruCodeFinder).to receive(:new).and_return(
          worker
        )

        expect(worker).to receive(:find).with(id)

        Trusona::TruCode.find(id)
      end

      context 'and when it goes well' do
        it 'returns the TruCode from the API' do
          tru_code = double
          worker = double(find: tru_code)
          id = '1'
          allow(Trusona::Workers::TruCodeFinder).to receive(:new).and_return(
            worker
          )

          expect(Trusona::TruCode.find(id)).to eq(tru_code)
        end
      end

      context 'or there is a problem' do
        it 'should be obvious what the problem was' do
          allow(Trusona::Workers::TruCodeFinder).to(
            receive(:new).and_raise(Trusona::TrusonaError)
          )

          expect { Trusona::TruCode.find(1) }.to(
            raise_error(Trusona::TrusonaError)
          )
        end
      end
    end

    describe 'by creating a new TruCode' do
      context 'and everything goes according to plan' do
        it 'tells the worker to create the code' do
          worker = double(create: double)
          code = double
          expect(Trusona::Workers::TruCodeCreator).to receive(:new).and_return(
            worker
          )

          expect(worker).to receive(:create).with(code)

          Trusona::TruCode.create(code)
        end
      end

      context 'or when there is a problem' do
        context 'and the problem is that the TruCode resource is invalid' do
          it 'it will be obvious that there was a problem with the resource' do
            allow(Trusona::Workers::TruCodeCreator).to receive(
              :new
            ).and_raise(Trusona::InvalidResourceError)

            expect { Trusona::TruCode.create(double) }.to raise_error(
              Trusona::InvalidResourceError
            )
          end
        end
        context 'and the problem is that the Trusona API is broken' do
          it 'it will be be obvious that there was a problem with the API' do
            allow(Trusona::Workers::TruCodeCreator).to receive(
              :new
            ).and_raise(Trusona::ApiError)

            expect { Trusona::TruCode.create(double) }.to raise_error(
              Trusona::ApiError
            )
          end
        end
        context 'and the problem is that request was unauthorized' do
          it 'it will be be obvious that the configured token or secret are wrong' do
            allow(Trusona::Workers::TruCodeCreator).to receive(
              :new
            ).and_raise(Trusona::UnauthorizedRequestError)

            expect { Trusona::TruCode.create(double) }.to raise_error(
              Trusona::UnauthorizedRequestError
            )
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
