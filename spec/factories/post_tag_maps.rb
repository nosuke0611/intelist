FactoryBot.define do
  factory :post_tag_map do
    sequence(:post_id) { |n| n }
    sequence(:tag_id) { |n| n }
  end
end
