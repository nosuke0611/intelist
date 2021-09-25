FactoryBot.define do
  factory :post do
    sequence(:id) { |n| n }
    sequence(:item_id) { |n| n }
    sequence(:content) { |n| "testcontent-#{n}" }
    assosiation { :user }
    assosiation { :item }
    assosiation { :tag }
  end
end
