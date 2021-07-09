class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.boolean :complete, default: false, null: false

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
