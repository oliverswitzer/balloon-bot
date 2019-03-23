require 'clients'

class App
  def self.run
    BalloonBot.instance.on(:message, Hooks::Message.new)
    BalloonBot.run
  end

  def self.slack_bot_client
    BalloonBot.instance.send(:client)
  end
end