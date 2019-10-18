module Clients
  module DataAnalysis
    class TfIdfTermsAnalyzer
      def top_terms_for_documents(*documents)
        tfidf_documents = documents.map { |doc| TfIdfSimilarity::Document.new(doc) }

        model = TfIdfSimilarity::TfIdfModel.new(tfidf_documents)

        tfidf_documents.map do |doc|
          get_top_terms(doc, model)
        end
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
