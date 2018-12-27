require 'slack-ruby-bot'

class BalloonBot < SlackRubyBot::Bot
  command 'hold' do |client, data, match|
    client.say(channel: data.channel, text: 'holding')
  end
end

BalloonBot.run
