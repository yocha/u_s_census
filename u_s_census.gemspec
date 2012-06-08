# -*- encoding: utf-8 -*-
require File.expand_path('../lib/u_s_census/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yong Cha"]
  gem.email         = ["yocha@yahoo.com"]
  gem.description   = %q{Access US Census data}
  gem.summary       = %q{Access US Census data}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "u_s_census"
  gem.require_paths = ["lib"]
  gem.version       = USCensus::VERSION

	gem.add_development_dependency "rspec"
end
