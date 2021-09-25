FactoryBot.define do
  factory :post_tag_map do
    sequence(:id) { |n| n }
    sequence(:post_id) { |n| n }
    sequence(:tag_id) { |n| n }
  end
end
