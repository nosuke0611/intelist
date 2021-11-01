class Tag < ApplicationRecord
  has_many :post_tag_maps, dependent: :destroy
  has_many :posts, through: :post_tag_maps

  def related_tags
    related_post_ids = PostTagMap.where(tag_id: id).pluck(:post_id)
    used_tag_ids = []
    related_post_ids.each do |related_post_id|
      used_tag_ids << PostTagMap.where(post_id: related_post_id).pluck(:tag_id)
    end
    self_array = Array.new([self])
    related_tag_array = []
    used_tag_ids.flatten.each do |used_tag_id|
      related_tag_array << Tag.find(used_tag_id)
    end
    related_tag_array.flatten.uniq - self_array
  end

  scope :searched, ->(search_params) do
    return if search_params.blank?

    tag_name = search_params[:tag_name]
    where(['tag_name Like ?', "%#{tag_name}%"])
  end
end
