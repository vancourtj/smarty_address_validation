# frozen_string_literal: true

# @see https://github.com/smartystreets/smartystreets-ruby-sdk/tree/master
require 'smartystreets_ruby_sdk'
require './clients/smarty_client'

class SmartyAdapter
  def initialize(address)
    @address = address
    @lookup = SmartyStreets::USStreet::Lookup.new
  end

  # Adapts the address data into the correct shape for Smarty and calls the {SmartyClient}
  #
  # @return [SmartyStreets::USStreet::Candidate] the Smarty address verification result
  def validate_us_street_address
    build_lookup

    candidates = SmartyClient.new(@lookup).get_us_street_address_candidates

    # @note using "invalid" as the match type guarantees at least one result
    #   even when the address is invalid. This fact combined with candidates
    #   set as 1 means we will only have 1 result when the request is successful
    candidates[0]
  end

  private

  def build_lookup
    @lookup.street = @address[:street]
    @lookup.city = @address[:city]
    @lookup.zipcode = @address[:zip_code]
    @lookup.candidates = 1
    @lookup.match = SmartyStreets::USStreet::MatchType::INVALID
  end
end
