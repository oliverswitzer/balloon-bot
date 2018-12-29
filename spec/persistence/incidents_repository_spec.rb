require 'rspec'
require './persistence/incidents_repository'
require './core/entities/incident'

describe IncidentsRepository do
  describe '#save' do
    it 'should generate unique integer ids for each persisted incident' do
      incident1 = Incident.new(text: 'yo')
      incident2 = Incident.new(text: 'foo')

      persisted_incident1 = subject.save(incident1)
      persisted_incident2 = subject.save(incident2)

      expect(persisted_incident1.id).to be_a(Integer)
      expect(persisted_incident2.id).to be_a(Integer)
      expect(persisted_incident1.id).not_to eq(persisted_incident2.id)
    end

    it 'should generate a created_at timestamp for the incident' do
      persisted_incident = subject.save(Incident.new(text: 'yo'))

      expect(persisted_incident.created_at).to be_a(Time)
    end
  end
end