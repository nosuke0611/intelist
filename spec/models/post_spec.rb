require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Postモデルのバリデーション確認' do
    # バリデーションを通過するケース
    context 'ユーザー、アイテム、投稿内容、タグがある場合' do
      it '正常に登録できる' do
        expect(build(:post)).to be_valid
      end
    end
    # バリデーションを通過しないケース
    context 'ユーザーがいない場合' do
      it '投稿が作成できない' do
        expect(build(:post, user: nil)).to be_invalid
      end
    end
    context 'アイテムがない場合' do
      it '投稿が作成できない' do
        expect(build(:post, item: nil)).to be_invalid
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
