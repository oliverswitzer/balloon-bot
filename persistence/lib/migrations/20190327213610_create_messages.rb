class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :text
      t.text :timestamp
      t.text :channel_id

      t.timestamps
      t.belongs_to :incident
    end
  end
end
