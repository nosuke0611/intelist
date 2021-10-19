require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  let(:user) { create(:user) }
  let(:changed_tagname_post) { create(:changed_tagname_post) }
  describe '投稿時のタグに関する挙動確認' do
    before(:each) do
      changed_tagname_post
    end
    context '新しい名前のタグを使用した場合' do
      it '新規のインスタンスが作成される' do
        sign_in user
        post_params = { post: { item_name: 'テストアイテム', content: '新規タグでのテスト投稿です', tag_name: '新規タグ' } }
        expect do
          post posts_path, params: post_params
        end.to change(Tag, :count).by(1)
      end
    end
    context 'カンマ区切りで２つのタグ名称を使用した場合' do
      it '新規のインスタンスが２つ作成される' do
        sign_in user
        post_params = { post: { item_name: 'テストアイテム', content: '新規タグでのテスト投稿です', tag_name: '新規タグA,新規タグ2' } }
        expect do
          post posts_path, params: post_params
        end.to change(Tag, :count).by(2)
      end
    end
    context '既存タグと同名のタグを使用した場合' do
      it '既存のインスタンスが再利用される' do
        sign_in user
        post_params = { post: { item_name: 'テストアイテム', content: '同名タグでのテスト投稿です', tag_name: 'テストタグ' } }
        expect do
          post posts_path, params: post_params
        end.to change(Tag, :count).by(0)
      end
    end 
  end
end
