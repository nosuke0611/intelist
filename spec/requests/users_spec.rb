require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'ルーティングの確認' do
    let(:user) { create(:user) }
    context '未ログインユーザーによるアクセスの場合' do
      it 'フォロー一覧にアクセスできずログインページへリダイレクト' do
        get relationships_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end

      it 'フォロワー一覧にアクセスできずログインページへリダイレクト' do
        get relationships_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログイン済ユーザーによるアクセスの場合' do
      before(:each) do
        sign_in user
      end
      it 'フォロー一覧ページアクセスできる' do
        get relationships_user_path(user)
        expect(response).to have_http_status '200'
      end

      it 'フォロワー一覧ページアクセスできる' do
        get relationships_user_path(user)
        expect(response).to have_http_status '200'
      end
    end
  end
end