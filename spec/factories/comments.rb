FactoryBot.define do
  factory :comment do
    sequence(:id) { |n| n }
    sequence(:comment) { |n| "TESTCOMMENT-#{n}" }
    association :user
    association :post
  end
end
