require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'Post/ create' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) } 
    context 'params内容による挙動確認' do
      it 'アイテム名、タグ名ともに新規の場合は新規投稿作成を作成できる' do
        sign_in user
        test_params = { post: { item_name: 'テストアイテム', content: 'テスト投稿です', tag_name: 'テストタグ' } }
        expect do
          post posts_path, params: test_params
        end.to change(Post, :count).by(1)
      end
      it ' 既存タグと同名タグを使用していた場合は既存のインスタンスが再利用される' do
        sign_in user
        test_params1 = { post: { item_name: 'テストアイテム1', content: 'テスト投稿です', tag_name: 'テストタグ' } }
        post posts_path, params: test_params1
        test_params2 = { post: { item_name: 'テストアイテム2', content: 'テスト投稿です', tag_name: 'テストタグ' } }
        expect do
          post posts_path, params: test_params2
        end.to change(Tag, :count).by(0)
      end
      it '既存アイテムと同名アイテムを使用していた場合は既存のインスタンスが再利用される' do
        sign_in other_user
        test_params = { post: { item_name: 'テストアイテム', content: 'テスト投稿です', tag_name: 'テストタグ' } }
        post posts_path, params: test_params
        sign_out other_user
        sign_in user
        expect  do
          post posts_path, params: test_params
        end.to change(Item, :count).by(0)
      end
    end
  end
  describe 'Delete/ destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    context '本人による削除の場合' do
      it '投稿が削除される' do
        test_post = test_post = create(:post, user: user)
        sign_in user
        expect do
          delete post_path(test_post.id)
        end.to change(Post, :count).by(-1)
      end
    end
    context '他のユーザーによる削除の場合' do
      it '削除が失敗する' do
        test_post = test_post = create(:post, user: other_user)
        sign_in user
        expect do
          delete post_path(test_post.id)
        end.to change(Post, :count).by(0)
      end
    end
  end
end
