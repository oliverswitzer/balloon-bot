require_relative '../../../spec_helper'

describe Core::IncidentAnalysis::FetchIncidents do
  let(:incidents_repository) { FakeIncidentsRepository.new }
  let(:incidents_analyzer) { spy(Core::IncidentAnalysis::IncidentTermsAnalyzer) }

  subject do
    Core::IncidentAnalysis::FetchIncidents.new(
      incidents_repository: incidents_repository,
      incidents_analyzer: incidents_analyzer
    )
  end

  describe 'incident analysis' do
    let(:incident_one) { Core::EntityFactory.build_incident_with_messages }
    let(:incident_two) { Core::EntityFactory.build_incident_with_messages }
    let(:incident_three) { Core::EntityFactory.build_incident_with_messages }

    before do
      incidents_repository.save(incident_one)
      incidents_repository.save(incident_two)
      incidents_repository.save(incident_three)
    end

    it 'returns incidents with terms metadata' do
      expect(incidents_analyzer).to receive(
        :compute_top_terms_for
      )
        .with({ incidents: [incident_one, incident_two, incident_three] })
        .and_return([
          ['term 1 for incident 1', 'term 2 for incident 1'],
          ['term 1 for incident 2', 'term 2 for incident 2'],
          ['term 1 for incident 3']
        ])

      result = subject.execute

      expect(result.length).to eq(3)
      expect(result[0].incident).to eq(incident_one)
      expect(result[0].terms).to contain_exactly(
        'term 1 for incident 1', 'term 2 for incident 1'
      )
      expect(result[1].incident).to eq(incident_two)
      expect(result[1].terms).to contain_exactly(
        'term 1 for incident 2', 'term 2 for incident 2'
      )
    end
  end
end
