require 'spec_helper'

RSpec.describe AddressFormatService do
  describe '#call' do
    let(:original_address) do
      {
        street: '143 e Maine Street',
        city: 'Columbus',
        zip_code: '43215'
      }
    end

    subject { described_class.new(original_address, validated_address).call }

    context 'when there is a validated address' do
      let(:validated_address) do
        {
          delivery_line: '143 E Main St',
          city: 'Columbus',
          zip_code: '43215',
          zip_plus_4: '5370'
        }
      end

      it 'returns the formatted original and validated address string' do
        expected_result = '143 e Maine Street, Columbus, 43215 -> 143 E Main St, Columbus, 43215-5370'

        expect(subject).to eq(expected_result)
      end
    end

    context 'when there is not a validated address' do
      let(:validated_address) { nil }

      it 'returns the formatted original address with the invalid address message string' do
        expected_result = '143 e Maine Street, Columbus, 43215 -> Invalid Address'

        expect(subject).to eq(expected_result)
      end
    end
  end
end
