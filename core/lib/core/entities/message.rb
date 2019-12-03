require_relative './keyword_struct'

module Core
  MESSAGE_FIELDS = [:id, :incident, :text, :timestamp, :channel_id, :author_id, :created_at]

  Message = Core::KeywordStruct.new(
    *MESSAGE_FIELDS
  )
end
