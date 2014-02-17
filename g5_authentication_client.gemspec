$:.push File.expand_path("../lib", __FILE__)
require "g5_authentication_client/version"

Gem::Specification.new do |s|
  s.name        = "g5_authentication_client"
  s.version     = G5AuthenticationClient::VERSION
  s.authors     = ["g5"]
  s.email       = ["engineering@g5searchmarketing.com"]
  s.homepage    = "http://getg5.com"
  s.summary     = %q{client for g5 OAuth provider}
  s.description = %q{client for g5 OAuth provider}

  s.rubyforge_project = "g5_authentication_client"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ["lib"]

  s.add_dependency('modelish', '~> 0.3')
  s.add_dependency('configlet', '~> 2.1')
  s.add_dependency('oauth2')
  s.add_dependency('addressable')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('webmock')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('codeclimate-test-reporter')
  s.add_development_dependency('yard')
  s.add_development_dependency('rdiscount')
  s.add_development_dependency('vcr')
end
