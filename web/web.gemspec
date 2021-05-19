Gem::Specification.new do |gem|
  gem.name = 'web'
  gem.author = ''
  gem.summary = ''
  gem.version = '0.0.0'

  gem.add_dependency 'rake'
  gem.add_dependency 'rails', '~> 6.0'
  gem.add_dependency 'pg'
  gem.add_dependency 'puma', '>= 3.7', '< 6.0'
  gem.add_dependency 'tzinfo-data'
  gem.add_dependency 'dotenv'
  gem.add_dependency 'olive_branch'

  gem.add_dependency 'clients'
  gem.add_dependency 'core'
  gem.add_dependency 'persistence'

  gem.add_development_dependency 'pry-rails'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec_junit_formatter'
end
