require_relative '../spec_helper'

describe Clients::Slack::SlackClientWrapper do
  let(:slack_web_client_spy) { spy(Slack::Web::Client) }
  let(:slack_bot_client_spy) do
    spy(SlackRubyBot::Client,
      web_client: slack_web_client_spy
    )
  end

  subject do
    Clients::Slack::SlackClientWrapper.new(slack_bot_client_spy)
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

  describe '#url_for_message' do
    it 'should generate the url for the given slack message timestamp and channel_id' do
      subject.url_for_message(
        timestamp: '123',
        channel_id: 'foo'
      )

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
          channel: 'some-channel-id',
          text: 'foo'
        )
    end
  end

  describe '#channel_name' do
    before do
      expect(slack_web_client_spy).to receive(:channels_info)
        .with(channel: 'some-channel-id')
        .and_return(
          channel: { name: 'This is a channel' }
        )
    end

    it 'returns the name for the given channel' do
      expect(subject.channel_name('some-channel-id')).to eq('This is a channel')
    end
  end

  private

  def mock_channels_list_response
    {
      channels: [
        {
          id: 'some-channel-id',
          name: ENV['DEPLOYMENTS_CHANNEL']
        }
      ]
    }
  end

end
