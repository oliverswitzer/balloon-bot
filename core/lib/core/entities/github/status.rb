module Core
  module Github
    class Status
      attr_reader :state, :context, :description

      FAILURE_STATE = 'failure'.freeze
      SUCCESS_STATE = 'success'.freeze

      def initialize(state:, description:)
        @state = state
        @context = "BalloonBot".freeze
        @description = description.freeze
      end

      def self.failure
        FailureStatus.new
      end

      def self.success
        SuccessStatus.new
      end
    end

    class FailureStatus < Status
      def initialize
        super(
          state: Status::FAILURE_STATE,
          description: 'Master is broken - Do not merge'
        )
      end
    end

    class SuccessStatus < Status
      def initialize
        super(
          state: Status::SUCCESS_STATE,
          description: 'Master is green - Feel free to merge'
        )
      end
    end
  end
end
