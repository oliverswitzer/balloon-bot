require_relative '../../../spec_helper'



describe Core::IncidentAnalysis::TextCleaner do
  before do
    allow(Core::IncidentAnalysis::MessagePresenter).to receive(:new) do |args|
      FakeMessagePresenter.new(message: args[:message])
    end
  end

  it 'should concatenate all the messages of an incident' do
    incident = Core::EntityFactory.build_incident_with_messages(
      messages: [
        message_for('yo'),
        message_for('sup whats happenin'),
        message_for('things broke tho')
      ]
    )

    result = Core::IncidentAnalysis::TextCleaner.aggregated_text_for_incident(incident)

    expect(result).to eq(' yo sup whats happenin things broke tho')
  end

  class FakeMessagePresenter
    attr_reader :message

    def initialize(message:)
      @message = message
    end

    def cleaned_text
      message.text
    end
  end

  def message_for(text)
    Core::EntityFactory.build_message(text: text)
  end
end