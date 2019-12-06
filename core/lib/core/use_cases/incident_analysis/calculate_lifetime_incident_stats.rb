module Core
  module IncidentAnalysis
    class CalculateLifetimeIncidentStats
      attr_reader :incidents_repository

      def initialize(incidents_repository:)
        @incidents_repository = incidents_repository
      end

      def execute
        incidents = incidents_repository.find_all_resolved

        total_duration = incidents.reduce(0) do |acc, incident|
          acc += incident.duration_in_milliseconds
        end

        {
          total_duration: total_duration,
          average_duration: total_duration / incidents.size
        }
      end
    end
  end
end

