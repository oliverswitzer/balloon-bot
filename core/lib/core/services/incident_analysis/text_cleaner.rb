module Core
  module IncidentAnalysis
    class TextCleaner
      def self.aggregated_text_for_incident(incident)
        processed_text = incident.messages
          .map(&method(:clean_message))
          .join(' ')

        processed_text
      end

      def self.clean_message(message)
        Core::IncidentAnalysis::MessagePresenter.new(
          message: message
        ).cleaned_text
      end
    end
  end
end