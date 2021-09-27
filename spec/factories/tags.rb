FactoryBot.define do
  factory :tag do
    sequence(:tag_name ) { |n| "TESTTAG-#{n}" }
  end
end
