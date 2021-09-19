require 'rails_helper'

RSpec.describe 'フォロー機能のテスト', type: :system do
  let(:user) { create(:user) }
  let(:other_users) { create_list(:user, 20) }

  before do
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
    sign_in(user)
  end

  describe 'フォロー・フォロー解除ボタンの動作確認' do
    it 'フォロー解除するとフォロー数が－１' do
      visit user_path(user.following.first.id)
      expect do
        find_by_id('unfollow-btn').click
        expect(page).not_to have_link 'フォロー中'
        visit current_path
      end.to change(user.following, :count).by(-1)
    end

    it 'フォローするとフォロー数が＋１' do
      visit user_path(other_users.last.id)
      expect do
        find_by_id('follow-btn').click
        expect(page).not_to have_link 'フォローする'
        visit current_path
      end.to change(user.following, :count).by(1)
    end
  end
end