require 'rails_helper'

RSpec.describe Post, type: :model do
  
  let(:user) { create(:user) }
  let(:item) { create(:item) }
    
  describe 'Postモデルのバリデーション確認' do
    # バリデーションを通過するケース
    context 'ユーザー、アイテム、投稿内容がある場合' do
      it '正常に投稿できる' do
        testpost = user.posts.build(
          user_id: user.id,
          item_id: item.id,
          content: 'testcontent'
        )
        expect(testpost).to be_valid
      end
    end

    # バリデーションを通過しないケース
    context 'ユーザーがいない場合' do
      it '投稿が作成できない' do
        testpost = Post.new(
          item_id: item.id,
          content: 'testcontent'
        )
        expect(testpost.save).to be_falsey
      end
    end

    context 'アイテムがない場合' do
      it '投稿が作成できない' do
        testpost = user.posts.build(
          user_id: user.id,
          content: 'testcontent'
        )
        expect(testpost.save).to be_falsey
      end
    end
  end

  describe 'Postモデルの削除処理' do
    context 'Userモデルを削除した場合' do
      it '紐づく投稿も削除される' do
        user.posts.create(
          user_id: user.id,
          item_id: item.id,
          content: 'testcontent'
        )
        expect { user.destroy }.to change { Post.count }.by(-1)
      end
    end
  end
end
