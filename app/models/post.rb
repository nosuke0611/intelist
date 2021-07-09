class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tag_maps, dependent: :destroy
  has_many :tags, through: :post_tag_maps

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true

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
end
