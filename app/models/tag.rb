class Tag < ApplicationRecord
  has_many :item_tag_maps, dependent: :destroy
  has_many :items, through: :item_tag_maps
  has_many :post_tag_maps, dependent: :destroy
  has_many :posts, through: :post_tag_maps
end
