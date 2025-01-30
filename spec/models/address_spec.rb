# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Address do
  subject { described_class.new(raw_address) }

  let(:raw_address) do
    {
      street: '143 e Maine Street',
      city: 'Columbus',
      zip_code: '43215'
    }
  end

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

  let(:result) { SmartyStreets::USStreet::Candidate.new(response) }

  before do
    allow_any_instance_of(SmartyAdapter).to receive(:validate_us_street_address).and_return(result)
  end

  describe '#formatted_address' do
    it 'returns the formatted address string' do
      expected_result = '143 e Maine Street, Columbus, 43215 -> 143 E Main St, Columbus, 43215-5370'

      expect(subject.formatted_address).to eq(expected_result)
    end
  end
end
