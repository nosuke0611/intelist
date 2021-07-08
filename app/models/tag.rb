class Tag < ApplicationRecord
  has_many :item_tag_maps, dependent: :destroy
  has_many :items, through: :item_tag_maps
end
