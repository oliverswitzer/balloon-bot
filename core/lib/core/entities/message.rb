require_relative './keyword_struct'

module Core
  MESSAGE_FIELDS = [:id, :incident, :text, :timestamp, :channel_id]

  Message = Core::KeywordStruct.new(
    *MESSAGE_FIELDS
  )
end
