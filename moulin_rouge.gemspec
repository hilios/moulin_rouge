$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "moulin_rouge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "moulin_rouge"
  s.version     = MoulinRouge::VERSION
  s.authors     = ["Edson Hilios"]
  s.email       = ["edson.hilios@gmail.com"]
  s.homepage    = "github.com/hilios/moulin_rouge"
  s.summary     = "TODO: Summary of MoulinRouge."
  s.description = "TODO: Description of MoulinRouge."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "cancan"

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
end
