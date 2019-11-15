class FakeIncidentsRepository
  attr_reader :incidents

  def initialize
    @incidents = []
  end

  def save(incident)
    if incident.id.nil?
      incident.id = @incidents.length + 1
      incident.created_at = incident.created_at || Time.now

      @incidents << incident

      incident
    else
      index_to_update = @incidents.find_index { |saved_incident| saved_incident.id == incident.id }

      @incidents[index_to_update] = incident
    end
  end

  def find_last_unresolved
    @incidents
      .sort { |x, y| y.created_at <=> x.created_at }
      .detect { |incident| incident.resolved_at.nil? }
  end

  def find_all_resolved
    @incidents
      .select { |incident| !incident.resolved_at.nil? }
  end

  def find(id)
    @incidents.find { |incident| incident.id == id }
  end

  def find_by_created_at_with_messages(lower_bound: nil, upper_bound: nil)
    incidents = @incidents

    incidents = incidents.select { |incident| incident.created_at > lower_bound } if lower_bound
    incidents = incidents.select { |incident| incident.created_at < upper_bound } if upper_bound

    incidents
  end
end
