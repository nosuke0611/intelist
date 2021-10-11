require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:self_post) { create(:post, user: user) }
  let(:other_post) { create(:post, user: other_user) }
  let(:self_comment) { create(:comment, user: user) }
  let(:other_comment) { create(:comment, user: other_user) }
  before(:each) do
    sign_in user
  end
  describe 'Post/ create' do
    context '自分の投稿に対してコメントした場合' do
      it 'コメントが作成される' do
        comment_params = { comment: { user_id: user.id, post_id: self_post.id, comment: 'テストコメント' } }
        expect do
          post post_comments_path(self_post.id), params: comment_params
        end.to change(Comment, :count).by(1)
      end
    end
    context '他のユーザーの投稿に対してコメントした場合' do
      it 'コメントが作成される' do
        comment_params = { comment: { user_id: user.id, post_id: other_post.id, comment: 'テストコメント' } }
        expect do
          post post_comments_path(other_post.id), params: comment_params
        end.to change(Comment, :count).by(1)
      end
    end
  end
  describe 'Delete/ destory' do
    context '自分のコメントを削除しようとした場合' do
      it 'コメントが削除される' do
        comment_params = { post_id: self_comment.post.id, id: self_comment.id }
        expect do
          delete post_comment_path(comment_params)
        end.to change(Comment, :count).by(-1)
      end
    end
    context '他のユーザーのコメントを削除しようとした場合' do
      it '削除が失敗する' do
        comment_params = { post_id: other_comment.post.id, id: other_comment.id }
        expect do
          delete post_comment_path(comment_params)
        end.to change(Comment, :count).by(0)
      end
    end
  end
end
