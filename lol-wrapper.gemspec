# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lol/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-lol"
  spec.version       = Lol::VERSION
  spec.authors       = ["Matheus Porto"]
  spec.email         = ["matheus.pereira11@gmail.com"]
  spec.description   = %q{Ruby wrapper to Riot Games API. Maps results to full blown ruby objects.}
  spec.summary       = %q{Ruby wrapper to Riot Games API}
  spec.homepage      = "https://github.com/MattPorto/lol-wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "ZenTest"
  spec.add_development_dependency "autotest-growl"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", ">= 1.8.0"
  spec.add_development_dependency "awesome_print"

  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "redis"
  spec.add_runtime_dependency "glutton_ratelimit"
end
