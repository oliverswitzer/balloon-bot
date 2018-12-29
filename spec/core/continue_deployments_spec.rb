require 'rspec'
require './core/continue_deployments'
require './slack_client_wrapper'

describe ContinueDeployments do
  let(:slack_client_spy) { spy(SlackClientWrapper) }
  subject do
    ContinueDeployments.new(
      chat_client: slack_client_spy
    )
  end

  describe '#execute' do
    it 'tells the specified deployments channel to continue deploys' do
      subject.execute

      expect(slack_client_spy).to have_received(:say)
                                    .with(message: SlackClientWrapper::BACK_TO_GREEN_MESSAGE)
    end

    it 'tells slack client to set channel topic for failure' do
      subject.execute

      expect(slack_client_spy).to have_received(:set_channel_topic)
                                    .with(message: SlackClientWrapper::GREEN_CHANNEL_TOPIC)
    end
  end
end