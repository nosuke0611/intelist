require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'アクセス時の挙動' do
    context '未ログインユーザーによるアクセス' do
      let(:user) { create(:user) }
      it 'フォロー一覧にアクセスできずログインページへリダイレクト' do
        get following_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end

      it 'フォロワー一覧にアクセスできずログインページへリダイレクト' do
        get followers_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログイン済ユーザーによるアクセス' do
      let(:user) { create(:user) }
      it 'フォロー一覧ページアクセスできる' do
        sign_in user
        get following_user_path(user)
        expect(response).to have_http_status '200'
      end

      it 'フォロワー一覧ページアクセスできる' do
        sign_in user
        get followers_user_path(user)
        expect(response).to have_http_status '200'
      end
    end
  end
end