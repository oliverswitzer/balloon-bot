Gem::Specification.new do |gem|
  gem.name = 'clients'
  gem.author = ''
  gem.summary = ''
  gem.version = '0.0.0'

  gem.require_path = "lib"
  gem.files = Dir["lib/**/*"]
  gem.test_files = Dir["spec/**/*"]

  gem.add_dependency 'sinatra'
  gem.add_dependency 'slack-ruby-bot'
  gem.add_dependency 'async-websocket'
  gem.add_dependency 'dry-struct'
  gem.add_dependency 'dry-types'
  gem.add_dependency 'octokit'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'dotenv'
end