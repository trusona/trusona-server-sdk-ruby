# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Workers::PairedTruCodeFinder do
  describe 'finding a paired trucode' do
    context 'the user calls the method without an id' do
      it 'raises an error' do
        expect {
          subject.find(nil)
        }.to raise_error(RuntimeError)
      end
    end
    context 'the service has a trucode object for the given id' do
      it 'calls the service to load the trucode and passes through the result' do
        stub_paired_trucode = Trusona::Resources::PairedTruCode.new(id: '12345', identifier: 'this is my identifier')
        service = double(get: stub_paired_trucode)
        expect(service).to(receive(:get)).with(having_attributes(id: 'fake_trucode_id'))

        sut = Trusona::Workers::PairedTruCodeFinder.new(service: service)

        paired_trucode = sut.find('fake_trucode_id')

        expect(paired_trucode).to be stub_paired_trucode
      end
    end
  end
end
