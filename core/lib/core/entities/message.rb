require_relative './keyword_struct'

module Core
  Message = Core::KeywordStruct.new(:id, :incident, :text, :timestamp, :channel_id)
end
