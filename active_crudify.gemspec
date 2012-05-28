# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|

  s.name        = "active_crudify"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["kame"]
  s.email       = ["kamechb@gmail.com"]
  s.homepage    = "http://github.com/kamechb/active_crudify"

  s.summary     = %q{DRY controller actions for Rails > 3.0 and keeps your controllers nice and skinny.}
  s.description = %q{DRY controller actions for Rails > 3.0 and keeps your controllers nice and skinny.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('actionpack', '>= 3.1')
  s.add_dependency('kaminari')
  s.add_dependency('responders')
end
