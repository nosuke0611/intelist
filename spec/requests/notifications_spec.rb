require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe '通知の作成確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) } 
    context '投稿にコメントされた場合' do
      it '通知が作成される' do
        test_post = create(:post, user: other_user)
        sign_in user
        expect  do
          post post_likes_path(test_post.id)
        end.to change(other_user.passive_notifications, :count).by(1)
      end
    end
  end
end
