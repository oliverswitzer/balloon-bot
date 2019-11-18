module Core
  module IncidentAnalysis
    class CalculateIncidentDurationOverTime
      attr_reader :incidents_repository

      def initialize(incidents_repository:)
        @incidents_repository = incidents_repository
      end

      def execute
        binding.pry
        incidents = incidents_repository.find_by_created_at_with_messages(
          lower_bound: 1.year.ago,
          upper_bound: Time.now
        ).select(&:is_resolved?)
        binding.pry

        {
          months: months,
          total_duration_per_month: durations_per_month(incidents)
        }
      end

      private def months
        Date::MONTHNAMES.compact
      end

      private def durations_per_month(incidents)
        months.map.with_index do |month, i|
          sum_incidents_for_month(i, incidents)
        end
      end

      private def sum_incidents_for_month(i, incidents)
        incidents.inject(0) do |total_duration, incident|
          if incident_occurred_in_month(i, incident)
            total_duration + incident.duration_in_milliseconds
          else
            total_duration
          end
        end
      end

      private def incident_occurred_in_month(i, incident)
        incident.created_at.month == i + 1
      end
    end
  end
end
