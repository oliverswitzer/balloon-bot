require_relative '../../spec_helper'
require 'active_support/all'

describe Core::Incident do
  describe '#duration_in_milliseconds' do
    it 'returns the duration between created_at and resolved_at in milliseconds' do
      incident = Core::EntityFactory.build_incident(
        created_at: 1.hour.ago.in_time_zone,
        resolved_at: Time.now.in_time_zone
      )

      ONE_HOUR_IN_MILLISECONDS = 60 * 60 * 1000
      expect(incident.duration_in_milliseconds).to eq(ONE_HOUR_IN_MILLISECONDS)
    end
  end
end
