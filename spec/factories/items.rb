FactoryBot.define do
  factory :item do
    sequence(:item_name) { |n| "TESTITEM-#{n}" }
  end
end
