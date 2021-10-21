class Post < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include HTTParty
  belongs_to :user
  counter_culture :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :tags, through: :post_tag_maps
  belongs_to :item
  counter_culture :item
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  default_scope -> { order('posts.created_at desc') }
  validates :user_id, presence: true, uniqueness: { scope: :item_id } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :item_id, presence: true

  # タグ作成
  def save_tags(tag_list)
    current_tags = tags.pluck(:tag_name) unless tags.nil?
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags

    old_tags.each do |old_tag|
      tags.delete Tag.find_by(tag_name: old_tag)
    end

    new_tags.each do |new_tag|
      add_tag = Tag.find_or_create_by(tag_name: new_tag)
      tags << add_tag
    end
  end

  # DBへのサムネイル情報保存
  def create_thumbnails
    return if url.blank?
    thumbnails = thumbnail
    update(ref_title: thumbnails[:title], ref_description: thumbnails[:description], ref_image: thumbnails[:image])
  end

  # APIでのデータ取得
  def thumbnail
    api_key = ENV['LINKWABE_API_KEY']
    base_url = 'https://api.linkpreview.net'
    alt_url = url
    HTTParty.post("#{base_url}?key=#{api_key}&q=#{alt_url}").symbolize_keys
  end

  # ユーザーがいいねしているかどうか
  def liked_by(user)
    Like.find_by(user_id: user, post_id: id)
  end

  # 完了ステータス変更
  def complete
    self.completed = true
    self.completed_at = Time.current
    save
  end

  def uncomplete
    self.completed = false
    self.completed_at = nil
    save
  end

  # 自分とフォローの投稿のみ表示
  scope :follow_only, ->(current_user) do
    where(user_id: [current_user.id, *current_user.following_ids])
  end

  # 自分の全投稿と他のユーザーの公開投稿のみ表示
  scope :public_and_by, ->(current_user) do
    where(user_id: current_user.id).or(where(private: false))
  end

  # マイアイテム絞り込み用
  scope :searched, ->(search_params) do
    return if search_params.blank?
    has_item_name(search_params[:item_name])
      .has_tag_name(search_params[:tag_name])
      .comp_status(search_params[:status])
  end

  # アイテム絞り込み検索用
  scope :has_item_name, ->(item_name) {
    joins(:item).merge(Item.where('item_name LIKE?', "%#{item_name}%")) if item_name.present?
  }

  scope :has_tag_name, ->(tag_name) {
    joins(:tags).merge(Tag.where('tag_name LIKE ?', "%#{tag_name}%")) if tag_name.present?
  }

  scope :has_user_name, ->(user_name) {
    joins(:user).merge(User.where('name LIKE ?', "%#{user_name}%"))
  }

  scope :comp_status, ->(status) {
    return                         if status == 'both'
    return where(completed: true)  if status == 'completed'
    return where(completed: false) if status == 'uncompleted'
  }

  # 投稿絞り込み用
  scope :all_liked_by, ->(user) {
    joins(:likes).merge(Like.where(user_id: user.id))
  }

  scope :all_commented_by, ->(user) {
    joins(:comments).merge(Comment.where(user_id: user.id))
  }

  # いいね通知作成用
  def create_notification_like!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and post_id = ? and action = ? ', current_user.id,
                               user_id, id, 'like'])
    return if temp.present?
    notification = current_user.active_notifications.build(
      post_id: id,
      visited_id: user_id,
      action: 'like'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  # コメント通知作成用
  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id, :created_at).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.build(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
