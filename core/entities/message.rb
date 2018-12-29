class Message
  attr_accessor :id, :incident, :text

  def initialize(id: nil, incident:, text:)
    @id = id
    @incident = incident
    @text = text
  end
end