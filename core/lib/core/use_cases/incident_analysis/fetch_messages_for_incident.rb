module Core
  module IncidentAnalysis
    class FetchMessagesForIncident
      attr_reader :messages_repository, :chat_client

      def initialize(messages_repository:, chat_client:)
        @messages_repository = messages_repository
        @chat_client = chat_client
      end

      def execute(incident_id:)
        messages = messages_repository.find_by_incident_id(incident_id)

        messages.map do |message|
          MessageResponse.new(
            text: message.text,
            channel_name: chat_client.channel_name(message.channel_id),
            slack_handle: chat_client.handle_name(message.author_id),
            created_at: message.created_at,
          )
        end
      end

      MessageResponse = Core::KeywordStruct.new(:text, :created_at, :channel_name, :slack_handle)
    end
  end
end