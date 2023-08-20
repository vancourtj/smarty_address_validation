require 'spec_helper'

RSpec.describe SmartyAddressService do
  describe '#call' do
    let(:address) do
      {
        street: '143 e Maine Street',
        city: 'Columbus',
        zip_code: '43215'
      }
    end

    subject { described_class.new(address).call }

    before do
      allow_any_instance_of(SmartyAdapter).to receive(:get_us_street_address_result).and_return(result)
    end

    context "when the address is valid" do
      let(:response) do
        {
          "analysis" => {
            "dpv_match_code" => 'Y'
          },
          "components" => {
            "city_name" => "Columbus",
            "zipcode" => "43215",
            "plus4_code" => "5370"
          },
          "delivery_line_1" => "143 E Main St"
        }
      end
      let(:result) { SmartyStreets::USStreet::Candidate.new(response) }

      it 'returns the relevant original and validated address hash' do
        expected_result = {
          original_address: {
            street: '143 e Maine Street',
            city: 'Columbus',
            zip_code: '43215'
          },
          validated_address: {
            delivery_line: '143 E Main St',
            city: 'Columbus',
            zip_code: '43215',
            zip_plus_4: '5370'
          }
        }

        expect(subject).to eq(expected_result)
      end
    end

    context "when the address is not valid" do
      let(:response) do
        {
          "analysis" => {
            "dpv_match_code" => 'N'
          }
        }
      end
      let(:result) { SmartyStreets::USStreet::Candidate.new(response) }

      it 'returns the original address and a nil validated address' do
        expected_result = {
          original_address: {
            street: '143 e Maine Street',
            city: 'Columbus',
            zip_code: '43215'
          },
          validated_address: nil
        }

        expect(subject).to eq(expected_result)
      end
    end
  end
end
