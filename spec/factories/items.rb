FactoryBot.define do
  factory :item do
    sequence(:id) { |n| n }
    sequence(:item_name) { |n| "TESTITEM-#{n}" }
  end
end
