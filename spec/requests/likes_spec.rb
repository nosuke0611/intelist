require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:self_post) { create(:post, user: user) }
  let(:other_post) { create(:post, user: other_user) }
  let(:self_like) { create(:like, user: user) }
  let(:other_like) { create(:like, user: other_user) }
  before(:each) do
    sign_in user
  end
  describe 'Post /create' do
    context '自分の投稿に対していいねした場合' do
      it 'いいねが作成される' do
        self_post
        expect do
          post post_likes_path(self_post.id)
        end.to change(Like, :count).by(1)
      end
    end
    context '他のユーザーのの投稿に対していいねした場合' do
      it 'いいねが作成される' do
        other_post
        expect do
          post post_likes_path(other_post.id)
        end.to change(Like, :count).by(1)
      end
    end
  end
  describe 'Delete/ destroy' do
    context '自分のいいねを削除しようとした場合' do
      it 'いいねが削除される' do
        like_params = { post_id: self_like.post.id, id: self_like.id }
        expect do
          delete post_like_path(like_params)
        end.to change(Like, :count).by(-1)
      end
    end
    context '他のユーザーののいいねを削除しようとした場合' do
      it 'いいねが削除される' do
        like_params = { post_id: other_like.post.id, id: other_like.id }
        expect do
          delete post_like_path(like_params)
        end.to change(Like, :count).by(0)
      end
    end
  end
end
