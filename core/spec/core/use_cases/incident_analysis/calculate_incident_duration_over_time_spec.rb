require_relative '../../../spec_helper'
require 'active_support/all'

describe Core::IncidentAnalysis::CalculateIncidentDurationOverTime do
  let(:fake_incidents_repository) { FakeIncidentsRepository.new }

  subject do
    Core::IncidentAnalysis::CalculateIncidentDurationOverTime.new(
      incidents_repository: fake_incidents_repository
    )
  end

  context 'when incidents exist over multiple months' do
    let(:thirty_minute_incident_in_march) do
      created_at = Time.new(2019, 3, 19)

      Core::EntityFactory.build_incident(
        created_at: created_at.in_time_zone,
        resolved_at: (created_at + 30.minutes).in_time_zone
      )
    end
    let(:one_hour_incident_in_march) do
      created_at = Time.new(2019, 3, 19)

      Core::EntityFactory.build_incident(
        created_at: created_at.in_time_zone,
        resolved_at: (created_at + 1.hour).in_time_zone
      )
    end
    let(:one_hour_incident_in_may) do
      created_at = Time.new(2019, 5, 19)

      Core::EntityFactory.build_incident(
        created_at: created_at.in_time_zone,
        resolved_at: (created_at + 1.hour).in_time_zone
      )
    end
    let(:one_hour_incident_in_july) do
      created_at = Time.new(2019, 7, 19)

      Core::EntityFactory.build_incident(
        created_at: created_at.in_time_zone,
        resolved_at: (created_at + 1.hour).in_time_zone
      )
    end

    before do
      fake_incidents_repository.save(thirty_minute_incident_in_march)
      fake_incidents_repository.save(one_hour_incident_in_march)
      fake_incidents_repository.save(one_hour_incident_in_may)
      fake_incidents_repository.save(one_hour_incident_in_july)
    end

    it 'return a list of months and the total incident duration for each month for the prior year' do
      AN_HOUR_AND_THIRTY_IN_MILLISECONDS = (1.hour + 30.minutes).to_i * 1000
      ONE_HOUR_IN_MILLISECONDS = 1.hour.to_i * 1000

      result = subject.execute

      expect(result[:months]).to eq(%w(January February March April May June July August September October November December))
      expect(result[:total_duration_per_month]).to eq([
        0, 0, AN_HOUR_AND_THIRTY_IN_MILLISECONDS, 0, ONE_HOUR_IN_MILLISECONDS, 0, ONE_HOUR_IN_MILLISECONDS, 0, 0, 0, 0, 0
      ])
    end
  end
end
