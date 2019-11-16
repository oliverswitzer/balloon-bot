module Core
  module IncidentAnalysis
    class CalculateIncidentDurationOverTime
      attr_reader :incidents_repository

      def initialize(incidents_repository:)
        @incidents_repository = incidents_repository
      end

      def execute
        grouped_incidents = incidents_repository.find_all_resolved_grouped_by_duration

        {
          months: months,
          total_duration_per_month: durations_per_month(grouped_incidents)
        }
      end

      private def durations_per_month(grouped_incidents)
        # WIP: Too tired to figure this out right now. Would like something like
        #
        # [0, 0, 36000, 0, 0, 36000, 0, etc...]... basically mapping 12 month array to durations
        #
        # durations = Array.new(12, 0)
        # durations.each_with_index do |duration, i|
        #   grouped_incidents.select { | |}
        # end
      end

      private def months
        Date::MONTHNAMES.compact
      end
    end
  end
end
