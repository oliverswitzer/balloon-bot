require './clients/github/github_client_wrapper'
require 'dotenv'
require 'pry'
require 'rspec'

TEST_BRANCH_1 = 'test-branch'
TEST_BRANCH_2 = 'other-test-branch'

describe GithubClientWrapper do
  before do
    Dotenv.load('.env.test')
  end

  let(:test_repo) { ENV['GITHUB_REPO'] }
  let(:github_client) { Octokit::Client.new(access_token: ENV['GITHUB_PERSONAL_ACCESS_TOKEN']) }

  describe '#open_pull_requests' do
    context 'when there are open pull requests' do
      let!(:test_pull_request_1) do
        github_client.create_pull_request(
          test_repo,
          'master',
          "oliverswitzer:#{TEST_BRANCH_1}",
          'some pull request title',
          'some pull request body'
        )
      end

      let!(:test_pull_request_2) do
        github_client.create_pull_request(
          test_repo,
          'master',
          "oliverswitzer:#{TEST_BRANCH_2}",
          'some other pull request title',
          'some other pull request body'
        )
      end

      it 'returns all open pull requests' do
        pull_requests = subject.open_pull_requests

        expect(pull_requests.size).to eq(2)
        expect(pull_requests.detect { |pr| pr.branch == TEST_BRANCH_1 }.head_sha).to eq(test_pull_request_1[:head][:sha])
        expect(pull_requests.detect { |pr| pr.branch == TEST_BRANCH_2 }.head_sha).to eq(test_pull_request_2[:head][:sha])
      end

      after do
        github_client.close_pull_request(
          test_repo,
          test_pull_request_1[:number]
        )

        github_client.close_pull_request(
          test_repo,
          test_pull_request_2[:number]
        )
      end
    end
  end

  describe '#set_status_for_commit' do
    context 'given a commit that exists in the repo' do
      let!(:test_pull_request) do
        github_client.create_pull_request(
          test_repo,
          'master',
          'oliverswitzer:test-branch',
          'some pull request title',
          'some pull request body'
        )
      end

      it 'sets a status for the commit SHA on that branch' do
        commit_SHA = test_pull_request[:head][:sha]

        subject.set_status_for_commit(
          commit_sha: commit_SHA,
          state: GithubClientWrapper::STATUS_FAILURE_STATE,
          context: 'Things happened',
          description: 'Because of stuff',
          more_info_url: 'http://www.example.com'
        )

        statuses_for_commit = github_client.statuses(
          test_repo,
          commit_SHA
        )

        expect(statuses_for_commit.first.state).to eq(GithubClientWrapper::STATUS_FAILURE_STATE)
        expect(statuses_for_commit.first.context).to eq('Things happened')
        expect(statuses_for_commit.first.description).to eq('Because of stuff')
        expect(statuses_for_commit.first.target_url).to eq('http://www.example.com')
      end

      after do
        github_client.close_pull_request(
          test_repo,
          test_pull_request[:number]
        )
      end
    end
  end
end
