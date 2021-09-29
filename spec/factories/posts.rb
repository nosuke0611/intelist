FactoryBot.define do
  factory :post do
    sequence(:id) { |n| n }
    sequence(:content) { |n| "TESTCONTENT-#{n}" }
    association :user
    association :item
    after(:build) do |post|
      tag = create(:tag)
      post.post_tag_maps << build(:post_tag_map, post: post, tag: tag)
    end

    factory :changed_itemname_post do
      association :item, item_name: 'テストアイテム'
    end

    # TESTTAG-nに加えてテストタグを登録する
    factory :changed_tagname_post do
      after(:build) do |post|
        tag = create(:tag, tag_name: 'テストタグ')
        post.post_tag_maps << build(:post_tag_map, post: post, tag: tag)
      end
    end
  end
end
