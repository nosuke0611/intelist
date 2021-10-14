class AddColumnToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :private, :boolean, null: false, default: false
  end
end
