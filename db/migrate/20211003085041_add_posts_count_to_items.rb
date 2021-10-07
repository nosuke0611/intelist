class AddPostsCountToItems < ActiveRecord::Migration[6.1]
  def self.up
    add_column :items, :posts_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :items, :posts_count
  end
end
