require 'yake/datadog'

require_relative 'lib/aws'
require_relative 'lib/github'

# Export AWS SecretsManager secret to ENV
SECRETS ||= Aws::SecretsManager::Client.new
SECRETS.export ENV['SECRET_ID'] || 'github/balloonbot'

# Set up GitHub client
GITHUB = GitHub::Client.new

handler :pop_inflate do |event|
  action        = event['action'].to_sym
  context       = event['context']       || 'Balloonbot'
  description   = event['description']   || '[no description]'
  pull_requests = event['pull_requests'] || []
  repo          = event['repo']          || 'kickstarter'
  target_url    = event['target_url']

  # Replace 4-byte chars from description (GitHub throws an error)
  description = description.each_char.map{ |c| c.bytes.count < 4 ? c : '?' }.join

  # Do pop/inflate
  res = GITHUB.send action, repo, context, description, target_url, *pull_requests

  # Return status URLs
  { status_urls: res.map(&:url) }
end
