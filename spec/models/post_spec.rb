require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Postモデルのバリデーション確認' do
    context 'バリデーションを通過するケース' do
      it 'ユーザー、アイテム、投稿内容、タグがある場合は正常に登録できる' do
        expect(build(:post)).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'ユーザーがいない場合は投稿が作成できない' do
        expect(build(:post, user: nil)).to be_invalid
      end
      it 'アイテムがない場合は投稿が作成できない' do
        expect(build(:post, item: nil)).to be_invalid
      end
      it '同一ユーザーが同じアイテムについて二度目の投稿はできない' do
        same_user = create(:user, id: 1)
        same_item = create(:item, id: 1, item_name:'same-name')
        create(:post, user: same_user, item: same_item)
        expect(build(:post, user: same_user, item: same_item)).to be_invalid
      end
    end
  end

  describe 'Postモデルの削除処理' do
    context 'Userモデルを削除した場合' do
      it '紐づく投稿も削除される' do
        testpost = create(:post)
        expect { testpost.user.destroy }.to change { Post.count }.by(-1)
      end
    end
  end
end
