FactoryBot.define do
  factory :post do
    sequence(:id) { |n| n }
    sequence(:content) { |n| "testcontent-#{n}" }
  end
end
