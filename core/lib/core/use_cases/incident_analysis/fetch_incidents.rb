module Core
  module IncidentAnalysis
    class FetchIncidents
      attr_reader :incidents_repository
      attr_reader :incidents_analyzer

      def initialize(incidents_repository:, incidents_analyzer:)
        @incidents_repository = incidents_repository
        @incidents_analyzer = incidents_analyzer
      end

      def execute(happened_after: nil, happened_before: nil)
        incidents = incidents_repository.find_by_created_at_with_messages(
          lower_bound: happened_after,
          upper_bound: happened_before
        )
        terms_per_incident = incidents_analyzer.compute_top_terms_for(incidents: incidents)

        incidents.map.with_index do |incident, i|
          IncidentResponse.new(
            terms: terms_per_incident[i],
            incident: incident
          )
        end
      end

      class IncidentResponse < Dry::Struct
        attribute :incident, Types.Instance(Core::IncidentWithMessages)
        attribute :terms, Types::Strict::Array.of(Types::Strict::String)
      end
    end
  end
end
