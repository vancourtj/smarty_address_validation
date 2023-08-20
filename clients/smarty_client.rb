# frozen_string_literal: true

# @see https://github.com/smartystreets/smartystreets-ruby-sdk/tree/master
require 'smartystreets_ruby_sdk'

class SmartyClient
  def initialize(lookup)
    @lookup = lookup
  end

  # Constructs the Smarty client and sends the request to the Smarty address verification api
  #
  # @return [Array<SmartyStreets::USStreet::Candidate>] the Smarty address verification candidates
  def get_us_street_address_candidates
    client.send_lookup(@lookup)

    @lookup.result
  end

  private

  def auth_id
    ENV['SMARTY_AUTH_ID']
  end

  def auth_token
    ENV['SMARTY_AUTH_TOKEN']
  end

  def credentials
    SmartyStreets::StaticCredentials.new(auth_id, auth_token)
  end

  def client
    SmartyStreets::ClientBuilder.new(credentials).with_licenses(['us-core-cloud']).build_us_street_api_client
  end
end
