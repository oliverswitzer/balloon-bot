require_relative '../../spec_helper'
require 'active_support/all'

describe Core::CalculateTotalIncidentDuration do
  let(:incidents_repository) { FakeIncidentsRepository.new }

  subject do
    Core::CalculateTotalIncidentDuration.new(
      incidents_repository: incidents_repository
    )
  end

  context 'when an incident of 1 hour and an incident of 30 minutes exist' do
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

    before do
      incidents_repository.save(thirty_minute_incident)
      incidents_repository.save(one_hour_incident)
    end

    it 'return 1 hour and 30 minutes in milliseconds' do
      AN_HOUR_AND_THIRTY_MINUTES_IN_MILLISECONDS = 5.4e6
      expect(subject.execute).to eq(AN_HOUR_AND_THIRTY_MINUTES_IN_MILLISECONDS)
    end
  end
end
