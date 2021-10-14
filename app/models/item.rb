class Item < ApplicationRecord
  has_many :posts, dependent: :nullify
  has_many :users, through: :posts
  validates :item_name, presence: true

  # 紐づいた投稿のタグをすべて取得
  def tags
    posts = self.posts.includes(:tags)
    tags_array = Array.new
    posts.each do |post|
      tags_array << post.tags
    end
    return tags_array.flatten.uniq
  end

  # 紐づいた投稿のユーザーをすべて取得（非公開で投稿しているユーザーは除外）
  def public_users_and(current_user)
    posts = self.posts.includes(:user).public_and_by(current_user)
    users_array = Array.new
    posts.each do |post|
      users_array << post.user
    end
    return users_array
  end

  # アイテムの期間別投稿数を取得
  def period_count(period)
    return self.posts.count if period == 'all'
    self.posts.where('created_at >= ?', period).count
  end

  # 絞り込み検索用
  scope :searched, -> (search_params) do
    return if search_params.blank?
    has_name(search_params[:item_name])
      .has_tag(search_params[:tag_name])
      .has_user(search_params[:user_name])
  end
  scope :has_name, -> (item_name){ where('item_name LIKE ?', "%#{item_name}%") if item_name.present? }
  scope :has_tag, -> (tag_name){ joins(:posts).merge(Post.has_tag_name tag_name) if tag_name.present? }
  scope :has_user, -> (user_name){ joins(:posts).merge(Post.has_user_name user_name) if user_name.present? }
  
end
