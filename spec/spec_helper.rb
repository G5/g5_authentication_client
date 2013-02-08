require 'rspec'

require 'webmock/rspec'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
  
end

require 'g5_authentication_client'
