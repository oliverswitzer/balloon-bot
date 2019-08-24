require_relative './keyword_struct'

module Core
  Message = Core::KeywordStruct.new(:id, :incident, :text, :timestamp, :channel_id) do
    UNWANTED_MESSAGE_REGEX = [
      %r{:hivequeen: `\[hivequeen\/\w*\]`},
      %r{:kickstarter: `\[kickstarter\/\w*\]`},
      %r{[0-9a-z]{}`},
      %r{:rosie: `\[rosie/\w*\]`}
    ].freeze

    def cleaned_message
      return '' if text === nil
      return '' if UNWANTED_MESSAGE_REGEX.any? do |regex|
        regex =~ text
      end

      text
        .gsub(/<.*>/, '')
        .gsub(/:.*:/, '')
        .gsub(/pop/, '')
    end
  end
end
