module Core
  module IncidentAnalysis
    class MessagePresenter < Dry::Struct
      attribute :message, Types.Instance(Core::Message)

      UNWANTED_MESSAGE_REGEX = [
        %r{:hivequeen: `\[hivequeen\/\w*\]`},
        %r{:kickstarter: `\[kickstarter\/\w*\]`},
        %r{[0-9a-z]{}`},
        %r{:rosie: `\[rosie/\w*\]`}
      ].freeze

      def cleaned_text
        return '' if message.text === nil
        return '' if UNWANTED_MESSAGE_REGEX.any? do |regex|
          regex =~ message.text
        end

        message.text
          .gsub(/<.*>/, '')
          .gsub(/:.*:/, '')
          .gsub(/pop/, '')
      end
    end
  end
end