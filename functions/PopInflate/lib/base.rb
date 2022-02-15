class Integer
  def seconds() self end
  def minutes() seconds * 60 end
  def hours() minutes * 60 end
  def days() hours * 24 end
  def weeks() days * 7 end

  alias :second :seconds
  alias :minute :minutes
  alias :hour :hours
  alias :day :days
  alias :week :weeks
end
