class Post < ApplicationRecord
  include HTTParty
  belongs_to :user
  counter_culture :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :tags, through: :post_tag_maps
  belongs_to :item
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true, uniqueness: { scope: :item_id } # rubocop:disable Rails/UniqueValidationWithoutIndex
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

  # 投稿に紐づくアイテム名を表示(idではなく)
  def item
    Item.find(self.item_id)
  end

  # ユーザーがいいねしているかどうか
  def liked_by(user)
    Like.find_by(user_id: user, post_id: id)
  end

  def thumbnail
    api_key = ENV['LINKWABE_API_KEY']
    base_url = 'https://api.linkpreview.net'
    alt_url = self.url
    HTTParty.post("#{base_url}?key=#{api_key}&q=#{alt_url}").symbolize_keys
  end

  # 完了ステータス変更
  def complete
    self.completed = true
    self.completed_at = Time.now.to_i
    self.save
  end

  def uncomplete
    self.completed = false
    self.completed_at = nil
    self.save
  end 

  # マイアイテム絞り込み用
  scope :searched, -> (search_params) do
    return if search_params.blank?
    has_item_name(search_params[:item_name])
      .has_tag_name(search_params[:tag_name])
      .comp_status(search_params[:status])
  end

  # アイテム絞り込み検索用
  scope :has_item_name, -> (item_name){
    joins(:item).merge(Item.where('item_name LIKE?', "%#{item_name}%")) if item_name.present?
  }

  scope :has_tag_name, -> (tag_name){
    joins(:tags).merge(Tag.where('tag_name LIKE ?', "%#{tag_name}%")) if tag_name.present?
  }

  scope :has_user_name, -> (user_name){
    joins(:user).merge(User.where('name LIKE ?', "%#{user_name}%"))
  }

  # 投稿絞り込み用
  scope :all_liked_by, -> (user){
    joins(:likes).merge(Like.where(user_id: user.id))
  }

  scope :all_commented_by, ->(user){
    joins(:comments).merge(Comment.where(user_id: user.id))
  }

  scope :comp_status, ->(status){
    return                         if status == 'both'
    return where(completed: true)  if status == 'completed'
    return where(completed: false) if status == 'uncompleted'
  }
end
