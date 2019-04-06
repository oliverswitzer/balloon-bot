require_relative './keyword_struct'

Message = KeywordStruct.new(:id, :incident, :text, :timestamp, :channel_id)