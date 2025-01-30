# frozen_string_literal: true

class Candidate
  INVALID_ADDRESS = 'Invalid Address'

  # @see https://www.smarty.com/docs/cloud/us-street-api#dpvmatchcode
  VALID_MATCH_CODES = %w[Y S D].freeze

  def initialize(smarty_candidate)
    @smarty_candidate = smarty_candidate
  end

  # Formats the candidate address for printing
  #
  # @return [String] the printable address string
  def formatted_address
    return INVALID_ADDRESS unless valid?

    "#{street}, #{city}, #{zip_code}-#{zip_plus4}"
  end

  private

  def city
    @smarty_candidate.components.city_name
  end

  # @see https://www.smarty.com/docs/cloud/us-street-api#deliveryline1
  def street
    @smarty_candidate.delivery_line_1
  end

  def zip_code
    @smarty_candidate.components.zipcode
  end

  def zip_plus4
    @smarty_candidate.components.plus4_code
  end

  def valid?
    VALID_MATCH_CODES.include?(@smarty_candidate.analysis.dpv_match_code)
  end
end
