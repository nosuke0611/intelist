class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false, default: ''
    add_column :users, :profile_photo, :string
    add_column :users, :profile_text, :string
  end
end
