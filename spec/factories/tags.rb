FactoryBot.define do
  factory :tag do
    sequence(:id) { |n| n }
    sequence(:tag_name) { |n| "TESTTAG-#{n}" }
  end
end
