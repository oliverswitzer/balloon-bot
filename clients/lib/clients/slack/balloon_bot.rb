def parse_message(data)
  {
    message: {
      text: data[:text],
      channel_id: data[:channel],
      timestamp: data[:ts]
    }
  }
end

module Clients
  module Slack
    class BalloonBot < SlackRubyBot::Bot
      PRIVATE_MESSAGE_ID_REGEX = /(D[A-Z0-9]{8}|G[A-Z0-9]{8})/

      command 'hold', 'pop' do |client, data, match|
        next if is_private_message? data[:channel]

        request = Core::HoldDeployments::Request.new(parse_message(data))

        Clients::HOLD_DEPLOYMENTS.execute(request)
      end

      command 'continue', 'inflate' do |client, data, match|
        next if is_private_message? data[:channel]

        Clients::CONTINUE_DEPLOYMENTS.execute
      end

      def self.is_private_message?(channel)
        channel =~ PRIVATE_MESSAGE_ID_REGEX
      end

      help do
        title 'BalloonBot'
        desc 'This Slack bot is meant to help let engineers in your organization know when master is broken.'

        command 'pop <description of issue>, hold <description of issue>' do
          desc 'will change the channel topic to a failing icon and prevent merges into master via a failing github status check. It is best to provide a reason for the failure'
          long_desc 'Usage: "@balloonbot pop <description of issue>; @balloonbot hold <description of the issue>"'
        end

        command 'inflate, continue' do
          desc 'will change the channel topic back to a passing icon and allow merges into master again'
          long_desc('Usage: "@balloonbot inflate; @balloonbot continue"')
        end
      end
    end
  end
end



module Hooks
  class Message
    def call(client, data)
      request = Core::RecordMessageForIncident::Request.new(
        parse_message(data)
      )

      Clients::RECORD_MESSAGE_FOR_INCIDENT.execute(request)
    end
  end
end
