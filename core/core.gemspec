Gem::Specification.new do |gem|
  gem.name = 'core'
  gem.author = ''
  gem.summary = ''
  gem.version = '0.0.0'

  gem.add_dependency 'dry-struct'
  gem.add_dependency 'dry-types'

  gem.files = Dir['lib/*.rb']
  gem.require_paths = %w(lib spec/public_test_helpers)
  gem.add_development_dependency 'rspec'
end
