class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.text :url
      t.text :ref_title
      t.text :ref_description
      t.text :ref_image
      t.boolean :completed, default: false, null: false
      t.datetime :completed_at, default: nil

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
