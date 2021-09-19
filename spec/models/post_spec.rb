require 'rails_helper'

RSpec.describe Post, type: :model do
  
  let(:user) { create(:user) }
  let(:item) { create(:item) }
    
  describe 'Postモデルの登録処理' do
    context 'バリデーションを通過する例' do
      it '正しいデータであれば正常に登録される' do
        testpost = user.posts.build(
          user_id: user.id,
          item_id: item.id,
          content: 'testcontent'
        )
        expect(testpost).to be_valid
      end
    end

    context 'バリデーションを通過しない例' do
      it 'ユーザーがいないとエラーとなる' do
        testpost = Post.new(
          item_id: item.id,
          content: 'testcontent'
        )
        expect(testpost.save).to be_falsey
      end

      it 'アイテムがないとエラーになる' do
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
