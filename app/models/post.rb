class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :tags, through: :post_tag_maps
  has_one :item
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :item_id, presence: true

  def save_tags(tag_list)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags

    old_tags.each do |old_tag|
      self.tags.delete Tag.find_by(tag_name: old_tag)
    end

    new_tags.each do |new_tag|
      add_tag = Tag.find_or_create_by(tag_name: new_tag)
      self.tags << add_tag
    end
  end

  def item
    Item.find(self.item_id)
  end

  def liked_by(user)
    Like.find_by(user_id: user, post_id: id)
  end

  # アイテム絞り込み検索用
  scope :has_tag_name, -> (tag_name){
    joins(:tags).merge(Tag.where('tag_name LIKE ?', "%#{tag_name}%"))
  }

  scope :has_user_name, -> (user_name){
    joins(:user).merge(User.where('name LIKE ?', "%#{user_name}%"))
  }

  # 投稿絞り込み用
  scope :liked_by_user, -> (user){
    joins(:likes).merge(Like.where(user_id: user.id))
  }

  scope :commented_by_user, ->(user){
    joins(:comments).merge(Comment.where(user_id: user.id))
  }
end
