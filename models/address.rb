# frozen_string_literal: true

require './models/candidate'
require './adapters/smarty_adapter'

class Address
  def initialize(raw_address)
    @raw_address = raw_address
    @candidate = Candidate.new(smarty_response)
  end

  # Formats the raw address and Smarty result into a printable string
  #
  # @return [String] the printable address string
  def formatted_address
    "#{raw_address_format} -> #{@candidate.formatted_address}"
  end

  private

  def raw_address_format
    "#{@raw_address[:street]}, #{@raw_address[:city]}, #{@raw_address[:zip_code]}"
  end

  def smarty_response
    SmartyAdapter.new(@raw_address).validate_us_street_address
  end
end
