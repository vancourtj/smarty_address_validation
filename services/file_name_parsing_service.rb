# frozen_string_literal: true

require 'optparse'

class FileNameParsingService
  def initialize(user_arguments)
    @user_arguments = user_arguments
  end

  # Parses the user supplied file name from the command line
  #
  # @return [String] file name
  def call
    parser.parse(@user_arguments)

    options[:file_name]
  end

  private

  def options
    @options ||= {}
  end

  def parser
    OptionParser.new do |opts|
      opts.on '--csv_file_name CSV' do |csv|
        options[:file_name] = csv
      end
    end
  end
end
