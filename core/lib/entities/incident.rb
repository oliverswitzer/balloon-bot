class Incident
  attr_accessor :id, :created_at, :resolved_at

  def initialize(id: nil, created_at: nil, resolved_at: nil)
    @id = id
    @created_at = created_at
    @resolved_at = resolved_at
  end
end