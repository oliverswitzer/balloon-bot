module Clients
  module Slack
    class Wrapper
      attr_reader :slack_web_client

      def initialize(slack_web_client)
        @slack_web_client = slack_web_client
      end

      def set_channel_topic(message:)
        slack_web_client.channels_setTopic(
          channel: "##{ENV['DEPLOYMENTS_CHANNEL']}",
          topic: message
        )
      end

      def url_for_message(timestamp:, channel_id:)
        response = slack_web_client.chat_getPermalink(
          channel: channel_id,
          message_ts: timestamp
        )

        response[:permalink]
      end

      def say(message:)
        slack_web_client.chat_postMessage(
          channel: "##{ENV['DEPLOYMENTS_CHANNEL']}",
          text: message
        )
      end

      def channel_name(channel_id)
        channel = all_channels.detect { |c| c[:id] == channel_id }

        channel[:name] if channel
      end

      def handle_name(user_id)
        user = all_users.detect { |u| u[:id] == user_id }

        user[:name] if user
      end

      private def all_users
        @all_users ||= slack_web_client.users_list[:members]
      end

      private def all_channels
        @all_channels ||= slack_web_client.channels_list[:channels]
      end
    end
  end
end
