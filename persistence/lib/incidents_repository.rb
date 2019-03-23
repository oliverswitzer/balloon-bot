class IncidentsRepository
  attr_reader :incidents
  
  def initialize
    @incidents = []
  end

  def save(incident)
    if incident.id.nil?
      incident.id = @incidents.length + 1
      incident.created_at = Time.now

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

  def find(id)
    @incidents.find { |incidents| incidents.id == id }
  end
end