FactoryBot.define do
  factory :user do 
    sequence(:id) { |n| n }
    sequence(:name) { |n| "TESTUSER#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { 'password' }
  end
end