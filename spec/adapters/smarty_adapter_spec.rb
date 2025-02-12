# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SmartyAdapter do
  describe '#validate_us_street_address' do
    let(:address) do
      {
        street: '123 Main St',
        city: 'Columbus',
        zip_code: '43215'
      }
    end

    before do
      allow_any_instance_of(SmartyClient).to receive(:get_us_street_address_candidates).and_return(%w[1 2])
    end

    subject { described_class.new(address) }

    it 'returns the first object from the SmartyClient result' do
      expect(subject.validate_us_street_address).to eq('1')
    end

    it 'builds the lookup using the supplied address' do
      lookup = subject.instance_variable_get(:@lookup)

      expect(lookup.street).to be_nil
      expect(lookup.city).to be_nil
      expect(lookup.zipcode).to be_nil

      subject.validate_us_street_address

      expect(lookup.street).to eq(address[:street])
      expect(lookup.city).to eq(address[:city])
      expect(lookup.zipcode).to eq(address[:zip_code])
    end
  end
end
