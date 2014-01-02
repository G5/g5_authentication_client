require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rspec'

require 'webmock/rspec'
require 'fakefs/spec_helpers'

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
end

require 'g5_authentication_client'
