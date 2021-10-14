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
        same_item = create(:item, id: 1, item_name: 'same-name')
        create(:post, user: same_user, item: same_item)
        expect(build(:post, user: same_user, item: same_item)).to be_invalid
      end
    end
  end
  describe 'Postモデルの削除処理' do
    context '投稿したユーザーを削除した場合' do
      it '紐づく投稿も削除される' do
        test_post = create(:post)
        expect { test_post.user.destroy }.to change { Post.count }.by(-1)
      end
    end
  end
  describe '取得範囲メソッドの動作確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:unfollowing_public_posts) { create(:post) }
    context 'follow_onlyメソッドを使用した場合' do
      it 'フォローしているユーザーの投稿のみを取得する' do
        user.follow(other_user)
        following_post = create(:post, user: other_user)
        expect(Post.follow_only(user)).to include(following_post)
        expect(Post.follow_only(user)).not_to include(unfollowing_public_posts)
      end
    end
    context 'public_and_byメソッドを使用した場合' do
      it '自分の投稿と公開投稿のみを取得する' do
        self_post = create(:private_post, user: user)
        private_post = create(:private_post, user: other_user)
        expect(Post.public_and_by(user)).to include(self_post)
        expect(Post.public_and_by(user)).to include(unfollowing_public_posts)
        expect(Post.public_and_by(user)).not_to include(private_post)
      end
    end
  end
end
