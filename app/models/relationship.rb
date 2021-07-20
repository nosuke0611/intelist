class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  counter_culture :follower, column_name: 'followings_count'
  belongs_to :followed, class_name: 'User'
  counter_culture :followed, column_name: 'followers_count'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
