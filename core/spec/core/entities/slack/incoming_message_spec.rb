require_relative '../../../spec_helper'

describe Core::Slack::IncomingMessage do
  describe '#is_private?' do
    context 'when its channel_id begins with D or G followed by 8 alphanumeric characters' do
      it 'returns true' do
        message1 = Core::EntityFactory.build_incoming_slack_message(channel_id: 'D12345A789')
        message2 = Core::EntityFactory.build_incoming_slack_message(channel_id: 'G12345A789')

        expect(message1.is_private?).to be(true)
        expect(message2.is_private?).to be(true)
      end
    end

    context 'if any other format' do
      it 'returns false' do
        message = Core::EntityFactory.build_incoming_slack_message(channel_id: 'C12345A789')

        expect(message.is_private?).to be(false)
      end
    end
  end
end