# Balloon Bot

This Slack bot is meant to help let engineers in your organization know when master is broken. It also will help gather information for post-mortems.

# Development

To run the bot locally, you first must setup your API token. 

1. Create a `.env` file that looks like `.env.sample` and fill it out
1. Run the app `bundle exec ruby balloon-bot.rb`

# Running tests

1. Create a `.env.test` file. 
- The credentials entered here will be used to run integration tests against `GithubClientWrapper` on a test repo
specified by the `GITHUB_REPO` env var. 
    - Note that two specific branches must exist in this repo for these tests to succeed, as indicated by the constants
    `TEST_BRANCH_1` and `TEST_BRANCH_2` in the spec.
    - It is recommended to use a separate github repo than what you use for local development
    to avoid possible data conflicts from simultaneous test runs 


`bundle exec rspec`
