# frozen_string_literal: true

class AddressFormatService
  INVALID_ADDRESS = "Invalid Address"

  def initialize(original_address, validated_address)
    @original_address = original_address
    @validated_address = validated_address
  end

  # Formats the original address and Smarty result into a printable string
  #
  # @return [String] the printable address string
  def call
    "#{original_address_formatted} -> #{validated_address_formatted}"
  end

  private

  def original_address_formatted
    "#{@original_address[:street]}, #{@original_address[:city]}, #{@original_address[:zip_code]}"
  end

  def validated_address_formatted
    return INVALID_ADDRESS unless @validated_address

    "#{@validated_address[:delivery_line]}, #{@validated_address[:city]}, "\
    "#{@validated_address[:zip_code]}-#{@validated_address[:zip_plus_4]}"
  end
end
