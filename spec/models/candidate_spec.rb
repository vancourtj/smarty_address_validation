# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Candidate do
  subject { described_class.new(result) }

  let(:result) { SmartyStreets::USStreet::Candidate.new(response) }

  describe '#formatted_address' do
    context 'when the smarty candidate is valid' do
      let(:response) do
        {
          'analysis' => {
            'dpv_match_code' => 'Y'
          },
          'components' => {
            'city_name' => 'Columbus',
            'zipcode' => '43215',
            'plus4_code' => '5370'
          },
          'delivery_line_1' => '143 E Main St'
        }
      end

      it 'returns the formatted address string' do
        expected_result = '143 E Main St, Columbus, 43215-5370'

        expect(subject.formatted_address).to eq(expected_result)
      end
    end

    context 'when the smarty candidate is invalid' do
      let(:response) do
        {
          'analysis' => {
            'dpv_match_code' => 'N'
          }
        }
      end

      it 'returns invalid address' do
        expected_result = Candidate::INVALID_ADDRESS

        expect(subject.formatted_address).to eq(expected_result)
      end
    end
  end
end
