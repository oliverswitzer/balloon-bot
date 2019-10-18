module Core
  module IncidentAnalysis
    class IncidentTermsAnalyzer
      attr_reader :text_analyzer

      def initialize(text_analyzer:)
        @text_analyzer = text_analyzer
      end

      def compute_top_terms_for(incidents: [])
        incident_documents = incidents
          .map { |incident| Core::IncidentAnalysis::TextCleaner.aggregated_text_for_incident(incident) }

        text_analyzer.top_terms_for_documents(*incident_documents)
      end
    end
  end
end