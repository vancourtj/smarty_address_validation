# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FileNameParsingService do
  describe '#call' do
    subject { described_class.new(argv).call }

    let(:file_name) { 'sample.csv' }

    before do
      stub_const('ARGV', argv)
    end

    context 'when the command line arguments are formatted correctly' do
      let(:argv) { %W[--csv_file_name #{file_name}] }

      it 'returns the file name' do
        expect(subject).to eq(file_name)
      end
    end

    context 'when the command line argument has too many arguments' do
      let(:argv) { %W[--csv_file_name #{file_name} --another_arg AAA] }

      it 'raises an invalid option error' do
        expect { subject }.to raise_error(OptionParser::InvalidOption)
      end
    end

    context 'when the command line argument has the incorrect argument' do
      let(:argv) { %W[--aaa_file_name #{file_name}] }

      it 'raises an invalid option error' do
        expect { subject }.to raise_error(OptionParser::InvalidOption)
      end
    end
  end
end
