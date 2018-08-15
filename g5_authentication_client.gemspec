# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'g5_authentication_client/version'

Gem::Specification.new do |s|
  s.name        = 'g5_authentication_client'
  s.version     = G5AuthenticationClient::VERSION
  s.authors     = ['Rob Revels', 'Maeve Revels']
  s.email       = ['rob.revels@getg5.com', 'maeve.revels@getg5.com']
  s.homepage    = 'https://github.com/G5/g5_authentication_client'
  s.summary     = 'Client for the G5 Auth service'
  s.description = 'Client for the G5 Auth service'

  s.rubyforge_project = 'g5_authentication_client'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ['lib']

  s.add_dependency('modelish')
  s.add_dependency('configlet', '~> 2.1')
  s.add_dependency('oauth2')
  s.add_dependency('addressable')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-its')
  s.add_development_dependency('webmock')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('codeclimate-test-reporter', '~> 1.0')
  s.add_development_dependency('yard')
  s.add_development_dependency('rdiscount')
  s.add_development_dependency('vcr')
end
