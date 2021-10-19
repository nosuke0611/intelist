require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  describe '通知の作成確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:other_post) { create(:post, user: other_user) }
    before(:each) do
      sign_in user
    end
    context '投稿にいいねされた場合' do
      it '通知が作成される' do
        other_post
        expect do
          post post_likes_path(other_post.id)
        end.to change(other_user.passive_notifications, :count).by(1)
      end
    end
    context '投稿にコメントされた場合' do
      it '通知が作成される' do
        comment_params = { comment: { user_id: user.id, post_id: other_post.id, comment: 'テストコメント' } }
        expect do
          post post_comments_path(other_post.id), params: comment_params
        end.to change(other_user.passive_notifications, :count).by(1)
      end
    end
    context 'フォローされた場合' do
      it '通知が作成される' do
        follow_params = { followed_id: other_user.id }
        expect do
          post relationships_path(follow_params)
        end.to change(other_user.passive_notifications, :count).by(1)
      end
    end
  end
end
