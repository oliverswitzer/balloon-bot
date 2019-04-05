class MessageRecord < ActiveRecord::Base
  self.table_name = 'messages'

  belongs_to :incident, class_name: 'IncidentRecord', foreign_key: 'incident_id'
end
