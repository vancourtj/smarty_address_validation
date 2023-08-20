# frozen_string_literal: true

PROJECT_ROOT = File.expand_path('..', __dir__)

FOLDERS_TO_INCLUDE = ['/adapters', '/clients', '/services'].freeze

FOLDERS_TO_INCLUDE.each do |folder|
  Dir.glob(File.join(PROJECT_ROOT, folder, '*.rb')).sort.each do |file|
    require file
  end
end
