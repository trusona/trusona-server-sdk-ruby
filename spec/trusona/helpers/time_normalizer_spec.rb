# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Helpers::TimeNormalizer do

  let(:sut) { Class.new { include Trusona::Helpers::TimeNormalizer }.new }

  describe '#normalize_time' do

    context 'when the time value is a Time object' do
      it 'should force the specified time to utc' do
        pst_time = Time.now.localtime('-07:00')
        expect(sut.normalize_time(pst_time)).to eq(pst_time.gmtime)
      end
    end

    context 'when the time value is a DateTime object' do
      it 'should force the specified date time to utc' do
        pst_time = DateTime.now
        expect(sut.normalize_time(pst_time)).to eq(pst_time.to_time.gmtime)
      end
    end

    context 'when the time value is a String' do
      it 'should be parsed into a Time instance' do
        string_time = DateTime.now.to_s
        expect(sut.normalize_time(string_time)).to be_a(Time)
      end

      it 'should be made to be utc' do
        string_time = DateTime.now.to_s
        expect(sut.normalize_time(string_time)).to(
          eq(DateTime.parse(string_time).to_time.gmtime)
        )
      end
    end

    context 'when the time value is a Date object' do
      it 'should ignore the specified date without a time component' do
        pst_time = Date.today
        expect(sut.normalize_time(pst_time)).to be_nil
      end
    end
  end
end