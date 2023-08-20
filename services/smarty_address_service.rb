# frozen_string_literal: true

require './adapters/smarty_adapter'

class SmartyAddressService
  # @see https://www.smarty.com/docs/cloud/us-street-api#dpvmatchcode
  VALID_MATCH_CODES = %w(Y S D)

  def initialize(address)
    @address = address
  end

  # Determines the valid address using Smarty
  #
  # @return [Hash] key-value pairs of the relevant address information for downstream consumption
  #  example:
  #    {
  #      original_address: {
  #        street: '143 e Maine Street',
  #        city: 'Columbus',
  #        zip_code: '43215'
  #      },
  #      validated_address: {
  #        delivery_line: '143 E Main St',
  #        city: 'Columbus',
  #        zip_code: '43215',
  #        zip_plus_4: '5370'
  #      }
  #    }

  def call
    {
      original_address: original_address,
      validated_address: validated_address
    }
  end

  private

  def result
    @result ||= SmartyAdapter.new(@address).get_us_street_address_result
  end

  def is_valid
    @is_valid ||= VALID_MATCH_CODES.include?(result.analysis.dpv_match_code)
  end

  def original_address
    {
      street: @address[:street],
      city: @address[:city],
      zip_code: @address[:zip_code]
    }
  end

  def validated_address
    return nil unless is_valid

    {
      delivery_line: result.delivery_line_1, # @see https://www.smarty.com/docs/cloud/us-street-api#deliveryline1
      city: result.components.city_name,
      zip_code: result.components.zipcode,
      zip_plus_4: result.components.plus4_code
    }
  end
end
