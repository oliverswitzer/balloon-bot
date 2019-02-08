module Github
  class Status
    attr_reader :state, :context, :description

    FAILURE_STATE = 'failure'.freeze

    def initialize(state:, context:, description:)
      @state = state
      @context = context.freeze
      @description = description.freeze
    end

    def self.failure
      FailureStatus.new
    end
  end

  private class FailureStatus < Status
    def initialize
      super(
        state: Status::FAILURE_STATE,
        context: 'BalloonBot: Master is currently broken',
        description: 'Please wait to merge your changes'
      )
    end
  end
end
