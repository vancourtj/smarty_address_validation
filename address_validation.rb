#!/usr/bin/env ruby

# frozen_string_literal: true

##
# USAGE:
# bundle exec ruby address_validation.rb --csv_file_name file.csv
##

require 'dotenv'
require 'csv'

Dotenv.load

require './models/address'

module AddressValidation
  def self.call
    user_arguments = ARGV
    file_name = FileNameParsingService.new(user_arguments).call

    addresses = []

    CSV.foreach(file_name, headers: true, header_converters: :symbol).each do |address|
      addresses << Address.new(address)
    end

    addresses.each do |address|
      puts address.formatted_address
    end
  end
end

AddressValidation.call
