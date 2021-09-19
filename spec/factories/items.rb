FactoryBot.define do
  factory :item do
    sequence(:id) { |n| n }
    sequence(:item_name) { |n| "testitem-#{n}" }
  end
end
