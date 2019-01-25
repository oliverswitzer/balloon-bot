# Balloon Bot

This Slack bot is meant to help let engineers in your organization know when master is broken. It also will help gather information for post-mortems.

# Development

To run the bot locally, you first must setup your API token. 

1. Create a `.env` file that looks like `.env.sample` and fill it out
1. Create a `.env.test` file that will be used to run integration tests against GithubClientWrapper on a test repo
specified by `GITHUB_REPO` env var.
    - Note that two specific branches must exist in this repo, as indicated by the test (test-branch, other-test-branch)
1. Run the app `bundle exec ruby balloon-bot.rb`

# Running tests

`bundle exec rspec`
