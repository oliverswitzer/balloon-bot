# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "celluloid-culture"
  spec.version       = "0.2"
  spec.authors       = ["Tony Arcieri", "Donovan Keme"]
  spec.email         = ["bascule@gmail.com", "code@extremist.digital"]

  spec.summary       = "The culture of Celluloid, in RubyGem form!"
  spec.description   = "In which we try to codify Celluloid's life philosophy as Ruby"
  spec.homepage      = "https://github.com/celluloid/culture"

  spec.files        = Dir["README.md", "CHANGES.md", "LICENSE.txt", "lib/**/*", "spec/**/*"]
  spec.require_path = "lib"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake",    "~> 10.0"
end
