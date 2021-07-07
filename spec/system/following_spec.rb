require 'rails_helper'

RSpec.describe 'フォロー機能の映テスト', type: :system do
  let(:user) { create(:user) }
  let(:other_users) { create_list(:user, 20) }

  before do
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
    sign_in (user)
  end

  scenario 'フォロー/フォロワー数の変動を確認' do
    visit following_user_path(user)
    find_by_id('following').click
    expect(user.following.count).to eq 10
    user.following.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end
    find_by_id('followers').click
    expect(user.followers.count).to eq 10
    user.followers.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end
  end

  scenario 'フォロー解除ボタンクリック時にフォロー数が－１' do
    visit user_path(user.following.first.id)
    expect do
      find_by_id('unfollow-btn').click
      expect(page).not_to have_link 'フォロー解除'
      visit current_path
    end.to change(user.following, :count).by(-1)
  end

  scenario 'フォローボタンクリック時にフォロー数が＋１' do
    visit user_path(other_users.last.id)
    expect do
      find_by_id('follow-btn').click
      expect(page).not_to have_link 'フォローする'
      visit current_path
    end.to change(user.following, :count).by(1)
  end
end