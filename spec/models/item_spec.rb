require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Itemモデルのバリデーション確認' do
    context 'バリデーションを通過するケース' do
      it 'アイテム名があれば正常に作成される' do
        expect(build(:item)).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'アイテム名がnilの場合作成されない' do
        expect(build(:item, item_name: nil)).to be_invalid
      end
    end
  end
  describe 'Itemモデルの作成処理' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    context '新たなアイテムに関して投稿した場合' do
      it '新規のインスタンスが作成される' do
        expect do
          create(:post)
        end.to change { Item.count }.by(1)
      end
    end
    context '既存のアイテムについて投稿した場合' do
      it '既存のインスタンスが使用される' do
        same_item = create(:item, item_name: 'same-name')
        create(:post, user: user, item: same_item)
        expect do
          create(:post, user: other_user, item: same_item)
        end.to change { Item.count }.by(0)
      end
    end
  end
  describe 'Itemモデルの削除処理' do
    context '紐づく投稿が削除された場合' do
      it '既存のアイテムインスタンスは削除されない' do
        test_post = create(:post)
        expect { test_post.destroy }.to change { Item.count }.by(0)
      end
    end
  end
  describe 'Item検索メソッドの動作確認' do
    let!(:test_user) { create(:user, name: 'テストユーザー') }
    let!(:other_items) { create_list(:item, 3) }
    let!(:changed_item_post) { create(:changed_itemname_post) } 
    let!(:changed_tag_post) { create(:changed_tagname_post, user: test_user) }
    context 'アイテム名で検索した場合' do
      it '該当する名前のアイテムのみが表示される' do
        search_params = { item_name: 'テスト' } 
        expect(Item.searched(search_params)).to include(changed_item_post.item)
        expect(Item.searched(search_params)).not_to include(other_items)
        expect(Item.searched(search_params)).not_to include(changed_tag_post.item)
      end
    end
    context 'タグ名で検索した場合' do
      it '該当するタグが紐づいたアイテムのみが表示される' do
        search_params = { tag_name: 'テスト' } 
        expect(Item.searched(search_params)).to include(changed_tag_post.item)
        expect(Item.searched(search_params)).not_to include(other_items)
        expect(Item.searched(search_params)).not_to include(changed_item_post.item)
      end
    end
    context 'ユーザー名で検索した場合' do
      it '該当するユーザーが投稿したアイテムのみが表示される' do
        search_params = { user_name: 'テスト' } 
        expect(Item.searched(search_params)).to include(changed_tag_post.item)
        expect(Item.searched(search_params)).not_to include(other_items)
        expect(Item.searched(search_params)).not_to include(changed_item_post.item)
      end
    end
    context '複数条件で検索した場合' do
      it 'AND条件として該当するアイテムのみが表示される' do
        search_params = { user_name: 'テスト', tag_name: 'テスト' } 
        expect(Item.searched(search_params)).to include(changed_tag_post.item)
        expect(Item.searched(search_params)).not_to include(other_items)
        expect(Item.searched(search_params)).not_to include(changed_item_post.item)
      end
    end
  end
end
