# coding: utf-8
require File.expand_path("../culture/sync", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "celluloid-pool"
  gem.version       = "0.20.5"
  gem.authors       = ["Tony Arcieri", "Tim Carey-Smith", "Donovan Keme"]
  gem.email         = ["tony.arcieri@gmail.com", "code@extremist.digital"]

  gem.summary       = "An implementation of an actor pool, based on the Celluloid concurrent object framework."
  gem.description   = "An implementation of an actor pool, based on the Celluloid concurrent object framework."
  gem.homepage      = "http://github.com/celluloid/celluloid-pool"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|examples|spec|features)/}) }
  gem.require_paths = ["lib"]

  Celluloid::Sync::Gemspec[gem]
end
