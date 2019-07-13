# -*- encoding: utf-8 -*-
require File.expand_path("../culture/sync", __FILE__)

Gem::Specification.new do |gem|
  gem.name         = "celluloid-extras"
  gem.version      = Celluloid::Extras::VERSION
  gem.platform     = Gem::Platform::RUBY
  gem.summary      = "Celluloid expansion, testing, and example classes."
  gem.description  = "Classes to support examples, benchmarks, or add special functionality."
  gem.licenses     = ["MIT"]

  gem.authors      = ["Donovan Keme", "Tony Arcieri"]
  gem.email        = ["code@extremist.digital", "tony.arcieri@gmail.com"]
  gem.homepage     = "https://github.com/celluloid/celluloid-extras"

  gem.files        = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|examples|spec|features)/}) }
  gem.require_path = "lib"

  Celluloid::Sync::Gemspec[gem]
end
