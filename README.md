# Balloon Bot

This Slack bot is meant to help let engineers in your organization know when master is broken. It also will help gather information for post-mortems.

# How it works

1. When something breaks, tell balloon bot!

![Hold deployments example](images/hold-deploys.png)

2. Balloon bot will set the channel topic

![Set the channel topic](images/channel-topic.png)

3. As well as make sure to set failing github statuses on all open pull requests

![It sets github status on all open pull requests](images/pr-status.png)

4. When you've fixed the issue, tell balloon bot and all will continue as if nothing ever happened.

![You can resume deployments too!](images/back-to-green.png)

# Development

To run the bot locally, you first must setup your API token. 

1. Create a `.env` file that looks like `.env.sample` and fill it out
1. Install foreman `gem install foreman`
1. Run the app `foreman start`

# Running tests

1. Create a `.env.test` file. 
- The credentials entered here will be used to run integration tests against `GithubClientWrapper` on a test repo
specified by the `GITHUB_REPO` env var. 
    - Note that two specific branches must exist in this repo for these tests to succeed, as indicated by the constants
    `TEST_BRANCH_1` and `TEST_BRANCH_2` in the spec.
    - It is recommended to use a separate github repo than what you use for local development
    to avoid possible data conflicts from simultaneous test runs 

1. `bundle exec rake test`

# Deployments

1. `git push heroku master`

If you want to run the app locally, you currently have to stop Heroku from running. This is because you will receive duplicate
messages from Heroku and your local machine. To stop the Heroku app from running:

`$ heroku ps:scale web=0`

To start it back up again

`$ heroku ps:scale web=1`
