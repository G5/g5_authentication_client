# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'test_frameworks'

require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'fakefs/spec_helpers'

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
end

require 'g5_authentication_client'
