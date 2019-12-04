require_relative '../spec_helper'

describe Clients::Slack::Wrapper do
  let(:slack_web_client_spy) { spy(Slack::Web::Client) }

  subject do
    Clients::Slack::Wrapper.new(slack_web_client_spy)
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
      ENV['DEPLOYMENTS_CHANNEL'] = 'some-channel'
    end

    after do
      ENV['DEPLOYMENTS_CHANNEL'] = nil
    end

    it 'should set the topic for the configured deployments channel' do
      subject.say(
        message: 'foo'
      )

      expect(slack_web_client_spy).to have_received(:chat_postMessage)
        .with(
          channel: '#some-channel',
          text: 'foo'
        )
    end
  end

  describe '#channel_name' do
    before do
      allow(slack_web_client_spy).to receive(:channels_list).and_return(
        {
          channels: [
            {
              id: 'some-channel-id',
              name: 'This is a channel'
            },
            {
              id: 'some-other-channel-id',
              name: 'Some other channel'
            }
          ]
        }
      )
    end

    it 'returns the name for the given channel' do
      expect(subject.channel_name('some-channel-id')).to eq('This is a channel')
    end
  end

  describe '#handle_name' do
    before do
      allow(slack_web_client_spy).to receive(:users_list).and_return(
        {
          members: [
            {
              id: 'some-user-id',
              name: 'userhandle'
            },
            {
              id: 'some-other-user-id',
              name: 'otheruserhandle'
            }
          ]
        }
      )
    end

    it 'returns the handle name for the given user id' do
      expect(subject.handle_name('some-user-id')).to eq('userhandle')
    end
  end
end
