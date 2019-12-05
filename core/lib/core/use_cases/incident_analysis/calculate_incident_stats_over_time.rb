module Core
  module IncidentAnalysis
    class CalculateIncidentStatsOverTime
      attr_reader :incidents_repository

      def initialize(incidents_repository:)
        @incidents_repository = incidents_repository
      end

      def execute(current_time: Time.now)
        incidents = incidents_repository.find_by_created_at_with_messages(
          lower_bound: current_time - 1.year,
          upper_bound: current_time
        ).select(&:is_resolved?)

        {
          months: months,
          total_duration_per_month: calculate_stats_per_month(incidents)
            .map { |monthly_stat| monthly_stat[:duration] },
          total_count_per_month: calculate_stats_per_month(incidents)
            .map { |monthly_stat| monthly_stat[:count] },
        }
      end

      private def months
        Date::MONTHNAMES.compact
      end

      private def calculate_stats_per_month(incidents)
        months.map.with_index do |month, i|
          sum_incidents_for_month(i, incidents)
        end
      end

      private def sum_incidents_for_month(month_index, incidents)
        monthly_stats = {
          duration: 0,
          count: 0
        }

        incidents.each do |incident|
          if incident_occurred_in_month(month_index, incident)
            monthly_stats[:duration] += incident.duration_in_milliseconds
            monthly_stats[:count] += 1
          end
        end

        monthly_stats
      end

      private def incident_occurred_in_month(month_index, incident)
        incident.created_at.month == month_index + 1
      end
    end
  end
end
