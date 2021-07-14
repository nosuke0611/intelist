class Item < ApplicationRecord
  has_many :posts
  has_many :users, through: :posts

  def tags
    posts = self.posts
    tags_array = Array.new
    posts.each do |post|
      tags_array << post.tags
    end
    return tags_array.flatten
  end

  def users
    posts = self.posts
    users_array = Array.new
    posts.each do |post|
      users_array << post.user
    end
    return users_array
  end
end
