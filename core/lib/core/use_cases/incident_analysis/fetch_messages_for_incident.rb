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
          MessageResponse.new(**message.to_h,
            channel_name: chat_client.channel_name(message.channel_id)
          )
        end
      end


      MessageResponse = Core::KeywordStruct.new(*Core::MESSAGE_FIELDS.concat([:channel_name]))
    end
  end
end