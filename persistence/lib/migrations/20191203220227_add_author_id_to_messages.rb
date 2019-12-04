class AddAuthorIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :author_id, :string
  end
end
