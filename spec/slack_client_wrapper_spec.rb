require './slack_client_wrapper'
require 'slack-ruby-bot'
require 'dotenv'

describe SlackClientWrapper do
  let(:slack_web_client_spy) { spy(Slack::Web::Client) }
  let(:slack_bot_client_spy) do
    spy(SlackRubyBot::Client,
        { web_client: slack_web_client_spy }
    )
  end

  subject do
    SlackClientWrapper.new(slack_bot_client_spy)
  end

  before do
    Dotenv.load
  end

  describe '#set_channel_topic' do
    it 'should set the topic for the configured deployments channel' do
      subject.set_channel_topic(
        message: 'yo'
      )

      expect(slack_web_client_spy).to have_received(:channels_setTopic)
                                        .with(
                                          channel: ENV['DEPLOYMENTS_CHANNEL'],
                                          topic: 'yo'
                                        )
    end
  end
  describe '#say' do
    it 'should set the topic for the configured deployments channel' do
      subject.say(
        message: 'foo'
      )

      expect(slack_bot_client_spy).to have_received(:say)
                                        .with(
                                          channel: ENV['DEPLOYMENTS_CHANNEL'],
                                          text: 'foo'
                                        )
    end
  end

end