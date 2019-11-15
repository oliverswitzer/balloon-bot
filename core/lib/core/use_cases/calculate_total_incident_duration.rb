module Core
  class CalculateTotalIncidentDuration
    attr_reader :incidents_repository

    def initialize(incidents_repository:)
      @incidents_repository = incidents_repository
    end

    def execute
      incidents = incidents_repository.find_all_resolved

      incidents.reduce(0) do |acc, incident|
        acc += incident.duration_in_milliseconds
      end
    end
  end
end

