require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let(:user) { create(:user) }
  let(:changed_tagname_post) { create(:changed_tagname_post) }
  describe '投稿時のタグに関する挙動確認' do
    context '既存タグと同名のタグを使用した場合' do
      before(:each) do
        changed_tagname_post
      end
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
