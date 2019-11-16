module Core
  module IncidentBehavior
    def duration_in_milliseconds
      ((resolved_at - created_at) * 24 * 60 * 60 * 1000).floor
    end

    def is_resolved?
      resolved_at.present?
    end
  end
end