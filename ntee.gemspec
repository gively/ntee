# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ntee/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nat Budin"]
  gem.email         = ["nbudin@gively.com"]
  gem.description   = %q{Utilities to support the Urban Institute's National Taxonomy of Exempt Entities}
  gem.summary       = %q{NTEE utilities for US nonprofit entity categorization}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ntee"
  gem.require_paths = ["lib"]
  gem.version       = NTEE::VERSION

  gem.add_development_dependency 'i18n'
  gem.add_development_dependency 'activesupport', '>= 3.0'
end
