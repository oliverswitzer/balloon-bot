require './clients/slack/slack_client_wrapper'
require './clients/slack/slack_message'
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
          channel: "##{ENV['DEPLOYMENTS_CHANNEL']}",
          topic: 'yo'
        )
    end
  end

  describe '#url_for' do
    it 'should generate the url for the given slack message' do
      subject.url_for(message: SlackMessage.new(
        timestamp: '123',
        channel_id: 'foo'
      ))

      expect(slack_web_client_spy).to have_received(:chat_getPermalink)
        .with(
          message_ts: '123',
          channel: 'foo'
        )
    end
  end

  describe '#say' do
    before do
      expect(slack_web_client_spy).to receive(:channels_list).and_return(
        mock_channels_list_response
      )
    end

    it 'should set the topic for the configured deployments channel' do
      subject.say(
        message: 'foo'
      )

      expect(slack_bot_client_spy).to have_received(:say)
        .with(
          channel: "some-channel-id",
          text: 'foo'
        )
    end
  end

  private

  def mock_channels_list_response
    {
      'channels' => [
        {
          'id' => 'some-channel-id',
          'name' => ENV['DEPLOYMENTS_CHANNEL']
        }
      ]
    }
  end

end