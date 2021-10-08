class Tag < ApplicationRecord
  has_many :post_tag_maps, dependent: :destroy
  has_many :posts, through: :post_tag_maps

  scope :searched, lambda { |search_params|
    return if search_params.blank?

    tag_name = search_params[:tag_name]
    where(['tag_name Like ?', "%#{tag_name}%"])
  }
end
