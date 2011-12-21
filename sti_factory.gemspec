# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sti_factory/version"

Gem::Specification.new do |s|
  s.name        = "sti_factory"
  s.version     = StiFactory::VERSION
  s.authors     = ["Andy Vanasse"]
  s.email       = ["andyvanasse@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "sti_factory"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  #s.add_development_dependency "activerecord"
  s.add_development_dependency "rails", " ~> 3.0"
  s.add_development_dependency "sqlite3-ruby"
  #s.add_development_dependency "supermodel"
end
