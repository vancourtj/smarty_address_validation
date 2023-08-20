#!/usr/bin/env ruby

##
# USAGE:
# bundle exec ruby address_validation.rb --csv_file_name file.csv
##

require 'dotenv'
require 'csv'

Dotenv.load

require './services/file_name_parsing_service'
require './services/smarty_address_service'
require './services/address_format_service'

module AddressValidation
  def self.call
    user_arguments = ARGV
    file_name = FileNameParsingService.new(user_arguments).call

    printable_addresses = []

    CSV.foreach(file_name, headers: true, header_converters: :symbol).each do |address|
      address_information = SmartyAddressService.new(address).call

      printable_addresses << AddressFormatService.new(address_information[:original_address],
                                                      address_information[:validated_address]).call
    end

    printable_addresses.each do |address|
      puts address
    end
  end
end

AddressValidation.call
