require 'rspec'
require './core/hold_deployments'
require './slack_client_wrapper'

describe HoldDeployments do
  let(:slack_client_spy) { spy(SlackClientWrapper) }
  subject do
    HoldDeployments.new(
      chat_client: slack_client_spy
    )
  end

  describe '#execute' do
    it 'tells the specified deployments channel to hold deploys' do
      subject.execute

      expect(slack_client_spy).to have_received(:say)
                                    .with(message: SlackClientWrapper::FAILURE_MESSAGE)
    end

    it 'tells slack client to set channel topic for failure' do
      subject.execute

      expect(slack_client_spy).to have_received(:set_channel_topic)
                                    .with(message: SlackClientWrapper::FAILURE_CHANNEL_TOPIC)
    end
  end
end