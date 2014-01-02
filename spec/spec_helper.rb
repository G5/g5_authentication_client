require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rspec'

require 'webmock/rspec'
require 'fakefs/spec_helpers'

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers

  # We need to explicitly disable webmock to report
  # coverage data to Code Climate
  config.after(:suite) { WebMock.disable! }
end

require 'g5_authentication_client'
