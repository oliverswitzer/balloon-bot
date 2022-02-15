require 'net/http'
require 'openssl'
require 'time'

require 'jwt'
require 'octokit'
require 'yake/logger'

require_relative 'base'

module GitHub
  class Authorizer
    include Yake::Logger

    def initialize(endpoint:nil, app_id:nil, private_key:nil)
      @endpoint    = endpoint    || ENV['GITHUB_API_ENDPOINT'] || 'https://api.github.com'
      @app_id      = app_id      || ENV['GITHUB_APP_ID']
      @private_key = private_key || ENV['GITHUB_PRIVATE_KEY']
    end

    def access_token
      access_token? ? @access_token : begin
        kickstarter   = -> (i) { i.dig('account', 'login') == 'kickstarter' }
        installation  = get('app/installations').select(&kickstarter).first
        @access_token = post("app/installations/#{installation['id']}/access_tokens")
      end
    end

    private

    def access_token?
      @access_token && @access_token['expires_at'] > (Time.now.utc - 1.minute).iso8601
    end

    def headers
      signing_key = OpenSSL::PKey::RSA.new @private_key
      payload = {
        iat: Time.now.to_i - 1.minute,
        exp: Time.now.to_i + 5.minutes,
        iss: @app_id,
      }
      auth = "Bearer #{JWT.encode payload, signing_key, 'RS256'}"

      { 'authorization' => auth, 'accept' => 'application/vnd.github.v3+json' }
    end

    def get(path, **query)
      request(Net::HTTP::Get, path, **query)
    end

    def post(path, body = nil, **query)
      request(Net::HTTP::Post, path, body, **query)
    end

    def request(klass, path, body = nil, **query)
      url  = File.join @endpoint, URI::DEFAULT_PARSER.escape(path)
      url += "?#{URI.encode_www_form(**query)}" unless query.empty?
      uri  = URI url
      req  = klass.new(uri, **headers)
      logger.info("#{req.method} #{uri}")
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        JSON.parse http.request(req, body).body
      end
    end
  end

  class Client
    include Yake::Logger

    def initialize(authorizer = nil)
      @authorizer ||= Authorizer.new
    end

    def client
      @client ||= Octokit::Client.new(access_token: @authorizer.access_token['token'])
    end

    def inflate(repo, context, description, target_url, *pull_requests)
      open_pull_requests(repo, *pull_requests).map do |pull_request|
        set_status_for_pull_request(:success, pull_request, context, description, target_url)
      end
    end

    def pop(repo, context, description, target_url, *pull_requests)
      open_pull_requests(repo, *pull_requests).map do |pull_request|
        set_status_for_pull_request(:failure, pull_request, context, description, target_url)
      end
    end

    def open_pull_requests(repo, *pull_requests)
      repo    = "kickstarter/#{repo}"
      options = { state: :open }
      logger.info "GET #{Octokit::Repository.path repo}/pulls #{options.to_json}"
      # https://docs.github.com/en/rest/reference/pulls#list-pull-requests
      client.pull_requests(repo, **options).select do |pull_request|
        pull_requests.empty? || pull_requests.include?(pull_request.number)
      end
    end

    def set_status_for_pull_request(status, pull_request, context, description, target_url)
      repo = pull_request.head.repo.full_name
      sha  = pull_request.head.sha

      options = {
        context:     context,
        description: description,
        target_url:  target_url,
      }

      logger.info "POST #{Octokit::Repository.path repo}/statuses/#{sha} #{status} #{options.to_json}"
      # https://docs.github.com/en/rest/reference/commits#create-a-commit-status
      client.create_status(repo, sha, status, **options)
    end
  end
end
