# -*- encoding: utf-8 -*-
require File.expand_path("../culture/sync", __FILE__)

Gem::Specification.new do |gem|
  gem.name         = "celluloid-fsm"
  gem.version      = "0.20.5"
  gem.platform     = Gem::Platform::RUBY
  gem.summary      = "Celluloid Finite State Machines"
  gem.description  = "Simple finite state machines with integrated Celluloid timeout support."
  gem.licenses     = ["MIT"]

  gem.authors      = ["Tony Arcieri", "Tim Carey-Smith", "Donovan Keme"]
  gem.email        = ["tony.arcieri@gmail.com", "code@extremist.digital"]
  gem.homepage     = "https://github.com/celluloid/celluloid-fsm"

  gem.files        = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|examples|spec|features)/}) }
  gem.require_path = "lib"

  Celluloid::Sync::Gemspec[gem]
end
