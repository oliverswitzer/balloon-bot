module Clients
  module Slack
    class Wrapper
      attr_reader :slack_web_client

      def initialize(slack_web_client)
        @slack_web_client = slack_web_client
      end

      def set_channel_topic(message:)
        slack_web_client.conversations_setTopic(
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
        channel = slack_web_client.conversations_info(channel: channel_id)

        channel.channel.name if channel
      end

      def handle_name(user_id)
        handle = all_users.detect { |u| u[:id] == user_id }.try(:[], :name)
        handle = lookup_bot_handle(user_id) if handle.nil?

        handle
      end

      private def all_users
        @all_users ||= slack_web_client.users_list[:members]
      end

      private def lookup_bot_handle(user_id)
        @bot_handle_mapping ||= {}

        begin
          return @bot_handle_mapping[user_id] if @bot_handle_mapping[user_id]

          handle = slack_web_client.bots_info(bot: user_id)
            .try(:[], :bot)
            .try(:[], :name)
          @bot_handle_mapping[user_id] = handle
          handle
        rescue Slack::Web::Api::Errors::SlackError
          nil
        end
      end
    end
  end
end
