FactoryBot.define do
  factory :post do
    sequence(:id) { |n| n }
    sequence(:content) { |n| "TESTCONTENT-#{n}" }
    private { false }
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
      association :item, item_name: 'タグ名変更アイテム'
      after(:build) do |post|
        tag = create(:tag, tag_name: 'テストタグ')
        post.post_tag_maps << build(:post_tag_map, post: post, tag: tag)
      end
    end

    factory :completed_post do
      completed { true }
      association :item, item_name: '完了済アイテム'
    end

    factory :private_post do
      private { true }
      content { '非公開投稿' }
      association :item, item_name: '非公開アイテム'
    end
  end
end
