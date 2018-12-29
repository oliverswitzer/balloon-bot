require 'rspec'
require './persistence/incidents_repository'
require './core/entities/incident'

describe IncidentsRepository do
  describe '#save' do
    context 'when id has not been set' do
      it 'generates unique integer ids for each persisted incident' do
        incident1 = Incident.new(resolved_at: nil)
        incident2 = Incident.new(resolved_at: nil)

        persisted_incident1 = subject.save(incident1)
        persisted_incident2 = subject.save(incident2)

        expect(persisted_incident1.id).to be_a(Integer)
        expect(persisted_incident2.id).to be_a(Integer)
        expect(persisted_incident1.id).not_to eq(persisted_incident2.id)
      end

      it 'generates a created_at timestamp for the incident' do
        persisted_incident = subject.save(Incident.new(resolved_at: nil))

        expect(persisted_incident.created_at).to be_a(Time)
      end
    end

    context 'when id is already set' do
      it 'updates the existing incident with the corresponding id' do
        RESOLVED_AT = Time.now

        subject.save(Incident.new(resolved_at: nil))
        persisted_incident = subject.save(Incident.new(resolved_at: nil))

        updated_incident = subject.save(
          Incident.new(id: persisted_incident.id, resolved_at: RESOLVED_AT)
        )

        expect(updated_incident.id).to eq(persisted_incident.id)
        expect(updated_incident.resolved_at).to eq(RESOLVED_AT)
      end
    end
  end

  describe '#find_last_unresolved' do
    context 'if there are no unresolved incidents' do
      it 'returns nil' do
        expect(subject.find_last_unresolved).to be_nil
      end
    end

    it 'should return the last unresolved incident' do
      subject.save(Incident.new(resolved_at: nil))
      sleep 1
      last_unresolved_incident = subject.save(Incident.new(resolved_at: nil))
      subject.save(Incident.new(resolved_at: Time.new(2018, 10, 31)))

      found_incident = subject.find_last_unresolved

      expect(found_incident).to eq(last_unresolved_incident)
    end
  end

  describe '#find' do
    it 'returns an incident matching the given id' do
      RESOLVED_AT = Time.now

      subject.save(Incident.new)
      incident = subject.save(Incident.new(resolved_at: RESOLVED_AT))
      subject.save(Incident.new)

      found_incident = subject.find(incident.id)

      expect(found_incident.resolved_at).to eq(RESOLVED_AT)
    end

  end
end