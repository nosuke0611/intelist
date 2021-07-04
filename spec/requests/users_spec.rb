require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '未ログインユーザーによるフォロー/フォロワー一覧ページアクセス時の挙動' do
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
end