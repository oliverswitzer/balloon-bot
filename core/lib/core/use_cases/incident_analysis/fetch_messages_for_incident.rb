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
            slack_handle: fetch_slack_handle(message),
            created_at: message.created_at,
          )
        end
      end

      MessageResponse = Core::KeywordStruct.new(:text, :created_at, :channel_name, :slack_handle)

      private def fetch_slack_handle(message)
        # We only started saving author_id to message entities after 12/03/2019. We need to check whether author_id exists
        # on the message so we don't make extraneous requests to Slack.
        chat_client.handle_name(message.author_id) if message.author_id
      end
    end
  end
end