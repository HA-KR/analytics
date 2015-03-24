# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'analytics/version'

Gem::Specification.new do |gem|
  gem.name          = "analytics"
  gem.version       = Analytics::VERSION
  gem.authors       = ["harikrishnan"]
  gem.email         = ["harikrishnan.a@infibeam.net"]
  gem.description   = %q{Analytics on Rails}
  gem.summary       = %q{Analytics on Rails}
  gem.homepage      = "https://github.com/aharikrishnan/analytics"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'actionpack', '>=2.3.8'
  gem.add_runtime_dependency 'activesupport', '>=2.3.8'
end
