require 'matrix'
require 'tf-idf-similarity'

module Core
  class GetTopIncidentTerms
    attr_reader :incidents_repository

    def initialize(incidents_repository:)
      @incidents_repository = incidents_repository
    end

    def execute
      messages_per_incident = incidents_repository.find_by_created_at_with_messages
                                                  .map(&:messages)

      concat_messages = messages_per_incident.map do |messages_arr|
        messages_arr.reduce('') { |agg_text, message| agg_text << " #{message.cleaned_message}" }
      end

      documents = concat_messages.map { |m| TfIdfSimilarity::Document.new(m) }

      model = TfIdfSimilarity::TfIdfModel.new(documents)

      documents.map do |doc|
        term_hash = {}
        doc.terms.each do |term|
          term_hash[term] = model.tfidf(doc, term)
        end

        term_hash.sort_by{|_,tfidf| -tfidf}.map(&:first).first(10)
      end
    end

  end
end
