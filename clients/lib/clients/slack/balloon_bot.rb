
def message_from_request(request)
  {
    text: request[:text],
    channel_id: request[:channel],
    author_id: request[:user] || request[:bot_id],
    timestamp: request[:ts]
  }
end

module Clients
  module Slack
    class BalloonBot < SlackRubyBot::Bot
      command 'hold', 'pop' do |client, data, match|
        incoming_message = Core::Slack::IncomingMessage.new(message_from_request(data))

        next unless is_from_deployments_channel? incoming_message

        Clients::HOLD_DEPLOYMENTS.execute(incoming_message)
      end

      command 'continue', 'inflate' do |client, data, match|
        incoming_message = Core::Slack::IncomingMessage.new(message_from_request(data))

        next unless is_from_deployments_channel? incoming_message

        Clients::CONTINUE_DEPLOYMENTS.execute
      end

      def self.is_from_deployments_channel?(message)
        return false if message.is_private?

        Clients::SLACK_CLIENT_WRAPPER.channel_name(message.channel_id) == ENV['DEPLOYMENTS_CHANNEL']
      end

      help do
        title 'BalloonBot'
        desc 'This Slack bot is meant to help let engineers in your organization know when master is broken.'

        command 'pop <description of issue>, hold <description of issue>' do
          desc 'will change the channel topic of the configured deployments channel to a failing icon and prevent merges into master via a failing github status check. It is best to provide a reason for the failure'
          long_desc 'Usage: "@balloonbot pop <description of issue>; @balloonbot hold <description of the issue>"'
        end

        command 'inflate, continue' do
          desc 'will change the channel topic of the configured deployments channel back to a passing icon and allow merges into master again'
          long_desc('Usage: "@balloonbot inflate; @balloonbot continue"')
        end
      end
    end
  end
end



module Hooks
  class Message
    def call(client, data)
      incoming_message = Core::Slack::IncomingMessage.new(message_from_request(data))

      return if incoming_message.is_private?

      Clients::RECORD_MESSAGE_FOR_INCIDENT.execute(incoming_message)
    end
  end
end
