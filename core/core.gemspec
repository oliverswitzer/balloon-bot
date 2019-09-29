Gem::Specification.new do |gem|
  gem.name = 'core'
  gem.author = ''
  gem.summary = ''
  gem.version = '0.0.0'

  gem.add_dependency 'dry-struct'
  gem.add_dependency 'dry-types'
  # TODO: Remove the two deps below--was on airplane so I couldn't install into clients
  # but wanted to remove this after moving tf-idf behavior into clients.
  gem.add_dependency 'tf-idf-similarity'
  gem.add_dependency 'matrix'

  gem.files = Dir['lib/*.rb']
  gem.require_paths = %w(lib spec/public_test_helpers)
  gem.add_development_dependency 'rspec'
end
