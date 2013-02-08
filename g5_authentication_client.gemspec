$:.push File.expand_path("../lib", __FILE__)
require "g5_authentication_client/version"

Gem::Specification.new do |s|
  s.name        = "g5_authentication_client"
  s.version     = G5AuthenticationClient::VERSION
  s.authors     = ["maeve"]
  s.email       = ["maeve.revels@g5platform.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "g5_authentication_client"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  
  s.require_paths = ["lib"]

  s.add_dependency('modelish', '>=0.1.2')
  s.add_dependency('configlet', '~>2.1')

  s.add_development_dependency('rspec', '~>2.6')
  s.add_development_dependency('webmock', '~>1.7')
  s.add_development_dependency('fakefs', '~>0.4')

  s.add_development_dependency('yard', '~>0.7')
  s.add_development_dependency('rdiscount', '~>1.6')

  # specify dependencies here, for example:
  # s.add_development_dependency "cucumber"
  # s.add_runtime_dependency "rest-client"
end
