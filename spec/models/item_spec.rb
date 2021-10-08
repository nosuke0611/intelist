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
end
