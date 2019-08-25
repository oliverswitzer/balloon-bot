require 'matrix'
require 'tf-idf-similarity'

module Core
  module IncidentAnalysis
    class GetTopIncidentTerms
      attr_reader :incidents_repository

      def initialize(incidents_repository:)
        @incidents_repository = incidents_repository
      end

      def execute
        messages_per_incident = incidents_repository
          .find_by_created_at_with_messages
          .map(&:messages)

        incident_documents = messages_per_incident.map(&method(:convert_messages_to_document))
        model = TfIdfSimilarity::TfIdfModel.new(incident_documents)

        incident_documents.map do |doc|
          get_top_terms(doc, model)
        end
      end

      private def convert_messages_to_document(messages)
        concatenated_messages = messages.reduce('') do |agg_text, message|
          agg_text << " #{cleaned_message(message)}"
        end

        TfIdfSimilarity::Document.new(concatenated_messages)
      end

      private def cleaned_message(message)
        message = Core::IncidentAnalysis::MessagePresenter.new(message: message)

        message.cleaned_text
      end

      private def get_top_terms(document, model)
        term_hash = {}
        document.terms.each do |term|
          term_hash[term] = model.tfidf(document, term)
        end

        term_hash.sort_by { |_, tfidf| -tfidf }.map(&:first).first(15)
      end
    end
  end
end
