require_relative './spec_helper'

incidents_repository_contract(
  Persistence::IncidentsRepository
)

describe Persistence::IncidentsRepository do
  let(:messages_repository) { Persistence::MessagesRepository.new }

  describe '#find_by_created_at' do
    context 'when lower bound date time is passed' do
      let(:lower_bound) { Time.now }

      let(:incident1_in_future) { Core::EntityFactory.build_incident(created_at: 2.days.from_now) }
      let(:incident2_in_future) { Core::EntityFactory.build_incident(created_at: 1.days.from_now) }
      let(:incident_in_past) { Core::EntityFactory.build_incident(created_at: 1.day.ago) }

      before do
        subject.save(incident1_in_future)
        subject.save(incident2_in_future)
        subject.save(incident_in_past)
      end

      it 'returns all incidents after that date time' do
        results = subject.find_by_created_at_with_messages(lower_bound: lower_bound)

        expect(results.length).to eq(2)
        expect(results.map(&:id)).to contain_exactly(incident1_in_future.id, incident2_in_future.id)
      end
    end

    context 'when upper bound date time is passed' do
      let(:upper_bound) { Time.now }

      let(:incident1_in_the_past) { Core::EntityFactory.build_incident(created_at: 2.days.ago) }
      let(:incident2_in_the_past) { Core::EntityFactory.build_incident(created_at: 1.days.ago) }
      let(:incident_in_the_future) { Core::EntityFactory.build_incident(created_at: 1.day.from_now) }

      before do
        subject.save(incident1_in_the_past)
        subject.save(incident2_in_the_past)
        subject.save(incident_in_the_future)
      end

      it 'returns all incidents before that upper bound date' do
        results = subject.find_by_created_at_with_messages(upper_bound: upper_bound)

        expect(results.length).to eq(2)
        expect(results.map(&:id)).to contain_exactly(
          incident1_in_the_past.id,
          incident2_in_the_past.id
        )
      end
    end

    context 'when both lower and upper bound date times are passed' do
      let(:lower_bound) { 1.day.ago }
      let(:upper_bound) { 1.day.from_now }

      let(:in_range_incident1) { Core::EntityFactory.build_incident(created_at: 23.hours.ago)}
      let(:in_range_incident2) { Core::EntityFactory.build_incident(created_at: 22.hours.from_now)}
      let(:out_of_range_incident1) { Core::EntityFactory.build_incident(created_at: 2.days.from_now)}
      let(:out_of_range_incident1) { Core::EntityFactory.build_incident(created_at: 25.hours.ago)}

      before do
        subject.save(in_range_incident1)
        subject.save(in_range_incident2)
        subject.save(out_of_range_incident1)
        subject.save(out_of_range_incident1)
      end

      it 'returns all incidents within that date range' do
        results = subject.find_by_created_at_with_messages(
          lower_bound: lower_bound,
          upper_bound: upper_bound
        )

        expect(results.length).to eq(2)
        expect(results).to contain_exactly(in_range_incident1, in_range_incident2)
      end
    end

    it 'returns the incident with messages' do
      incident = Core::EntityFactory.build_incident(created_at: 2.days.ago)
      subject.save(incident)
      message1 = Core::EntityFactory.build_message(incident: incident)
      message2 = Core::EntityFactory.build_message(incident: incident)
      messages_repository.save(message1)
      messages_repository.save(message2)

      subject.save(incident)

      result = subject.find_by_created_at_with_messages

      expect(result.first.messages.count).to eq(2)
    end
  end
end

