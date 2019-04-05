class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.timestamp :resolved_at

      t.timestamps
    end
  end
end
