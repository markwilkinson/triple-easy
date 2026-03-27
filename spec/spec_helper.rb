# frozen_string_literal: true

require 'bundler/setup'
require 'triple_easy' # This loads the gem and extends Object with triplify
require 'rdf'
require 'rdf/repository'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
