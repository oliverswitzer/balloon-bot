require 'yake/datadog'

class SlackEvent
  attr_reader :action, :repo, :message

  def initialize(event)
    @event = event
  end

  def to_slack
    {
      username:   'Balloonbot',
      icon_emoji: 'balloon',
      text:       'Choose balloonbot action',
      channel:    channel_id,
      user:       user_id,
      blocks:     blocks
    }
  end

  def blocks
    case action
    when 'inflate' then [ block_instructions, block_actions ]
    else [ block_why, block_instructions, block_actions ]
    end
  end

  def block_why
    {
      block_id:     'balloonbot_why',
      type:         'input',
      optional:      true,
      label:         plain_text("Why are you alerting <##{channel_id}>?"),
      element: {
        action_id:     'balloonbot_why',
        type:          'plain_text_input',
        placeholder:   plain_text('Write something (optional)'),
        initial_value: (message unless message.empty?),
      }.compact
    }
  end

  def block_instructions
    {
      block_id: 'balloonbot_instructions',
      type:     'section',
      text:     mrkdwn('*Freeze deploys with _Pop!_, or unfreeze them with _Inflate_*')
    }
  end

  def block_actions
    elements = [ block_action_repo ]
    elements << block_action_pop     unless action == 'inflate'
    elements << block_action_inflate unless action == 'pop'

    { block_id: 'balloonbot_actions', type: 'actions', elements: elements }
  end

  def block_action_repo
    {
      action_id:      'balloonbot_repo',
      type:           'static_select',
      initial_option: block_action_repo_initial_option,
      options:        [ block_action_repo_option_kickstarter, block_action_repo_option_rosie ]
    }
  end

  def block_action_repo_option_kickstarter
    { value: 'kickstarter', text: plain_text(':ksr-logo-white: Kickstarter') }
  end

  def block_action_repo_option_rosie
    { value: 'rosie', text: plain_text(':rosie: Rosie') }
  end

  def block_action_repo_initial_option
    case repo
    when 'rosie' then block_action_repo_option_rosie
    else block_action_repo_option_kickstarter
    end
  end

  def block_action_pop
    {
      action_id: 'balloonbot_pop',
      type:      'button',
      value:     'pop',
      text:      plain_text(':boom: Pop!'),
      confirm: {
        style:   'danger',
        title:   plain_text('Are you sure?'),
        text:    plain_text('This will freeze deploys for the selected project'),
        confirm: plain_text('Pop!'),
        deny:    plain_text('Cancel')
      }
    }
  end

  def block_action_inflate
    {
      action_id: 'balloonbot_inflate',
      type:      'button',
      value:     'inflate',
      text:      plain_text(':green_balloon: Inflate'),
      confirm: {
        style:   'primary',
        title:   plain_text('Are you sure?'),
        text:    plain_text('This will unfreeze deploys for the selected project'),
        confirm: plain_text('Inflate!'),
        deny:    plain_text('Cancel')
      }
    }
  end

  def mrkdwn(text)
    { type: 'mrkdwn', text: text }
  end

  def plain_text(text)
    { type: 'plain_text', text: text }
  end
end

class AppMentionEvent < SlackEvent
  def initialize(event)
    super
    _, @action, @repo, *message = @event.dig('event', 'text').split
    @message = message.join(' ')
  end

  def channel_id
    @event.dig('event', 'channel')
  end

  def user_id
    @event.dig('event', 'user')
  end
end

class SlashCommandEvent < SlackEvent
  def initialize(event)
    super
    @action, @repo, *message = event['text'].split
    @message = message.join(' ')
  end

  def channel_id
    @event['channel_id']
  end

  def user_id
    @event['user_id']
  end
end

handler :parse_text do |event|
  message = if event['type'] == 'event_callback'
    # @Kickbot {pop,inflate} *
    AppMentionEvent.new(event)
  else
    # /balloonbot *
    SlashCommandEvent.new(event)
  end

  message.to_slack
end
