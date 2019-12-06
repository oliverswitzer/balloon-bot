require_relative '../../../spec_helper'
require 'active_support/all'

describe Core::IncidentAnalysis::CalculateLifetimeIncidentStats do
  let(:incidents_repository) { FakeIncidentsRepository.new }

  subject do
    Core::IncidentAnalysis::CalculateLifetimeIncidentStats.new(
      incidents_repository: incidents_repository
    )
  end

  context 'when an incident of 1 hour, an incident of 30 minutes, and an incident of 15 minutes exist' do
    let(:thirty_minute_incident) do
      Core::EntityFactory.build_incident(
        created_at: 30.minutes.ago,
        resolved_at: Time.now
      )
    end
    let(:one_hour_incident) do
      Core::EntityFactory.build_incident(
        created_at: 1.hour.ago,
        resolved_at: Time.now
      )
    end
    let(:fifteen_minute_incident) do
      Core::EntityFactory.build_incident(
        created_at: 15.minutes.ago,
        resolved_at: Time.now
      )
    end

    before do
      incidents_repository.save(thirty_minute_incident)
      incidents_repository.save(one_hour_incident)
      incidents_repository.save(fifteen_minute_incident)
    end

    it 'return 1 hour and 45 minutes in milliseconds for total duration' do
      an_hour_and_thirty_minutes_in_milliseconds = 6.3e6

      expect(subject.execute[:total_duration]).to eq(an_hour_and_thirty_minutes_in_milliseconds)
    end

    it 'returns an average incident duration of 35 minutes' do
      thirty_five_minutes_in_milliseconds = 2.1e6

      expect(subject.execute[:average_duration]).to eq(thirty_five_minutes_in_milliseconds)
    end
  end
end
