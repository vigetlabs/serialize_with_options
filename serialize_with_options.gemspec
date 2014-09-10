# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "serialize_with_options/version"

Gem::Specification.new do |s|
  s.name        = "serialize_with_options"
  s.version     = SerializeWithOptions::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Eisinger"]
  s.email       = ["david.eisinger@gmail.com"]
  s.homepage    = "http://www.viget.com/extend/simple-apis-using-serializewithoptions"
  s.summary     = %q{Simple XML and JSON APIs for your Rails app}
  s.description = %q{Simple XML and JSON APIs for your Rails app}

  s.rubyforge_project = "serialize_with_options"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "~> 4.0"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "sqlite3"
end
