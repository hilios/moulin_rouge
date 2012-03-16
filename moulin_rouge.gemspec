$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "moulin_rouge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "moulin_rouge"
  s.version     = MoulinRouge::VERSION
  s.authors     = ["Edson Hilios"]
  s.email       = ["edson.hilios@gmail.com"]
  s.homepage    = "https://github.com/hilios/moulin_rouge"
  s.summary     = "Organize CanCan permissions in many files and DRY."
  s.description = "A wrapper to CanCan authorization system, that lets you declare permissions in many ruby files. Adds new functionalities allowing you do more with less code and DRY."

  s.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*", "init.rb"]
  s.test_files    = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "cancan"
  
  s.add_development_dependency "rails", "~> 3.0.9"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "simplecov"
end
