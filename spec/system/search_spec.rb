require 'rails_helper'

RSpec.describe '検索機能のテスト', type: :system do
  let(:user) { create(:user) }
  let(:other_users) { create_list(:user, 10) }
  let(:tags) { create_list(:tags, 5) }
  let(:post_tag_maps) { create_list(:post_tag_map, 5) }
  let(:posts) { create_list(:post, 5) }

  describe 'ユーザー一覧画面での検索機能テスト', js: true do
    before(:each) do
      user.name = 'テストユーザー'
      sign_in user
      other_users
    end
    context 'ユーザー名「テスト」で検索すると' do
      it '「テストユーザー」のみ表示される' do
        visit users_path
        fill_in 'search-username', with: 'テスト'
        find_by_id('search-submit-btn').click
        expect(page).to have_content 'テストユーザー'
        expect(page).not_to have_content 'TESTUSER'
        find_by_id('search-reset-btn').click
        expect(page).to have_content 'TESTUSER'
      end
    end
    context 'ユーザー名「TEST」で検索すると' do
      it '「テストユーザー」は表示されない' do
        visit users_path
        fill_in 'search-username', with: 'TEST'
        find_by_id('search-submit-btn').click
        expect(page).to have_content('テストユーザー', count: 1) # 自身のユーザー名がヘッダーに表示されるため1
        expect(page).to have_content 'TESTUSER'
        find_by_id('search-reset-btn').click
        expect(page).to have_content 'テストユーザー'
      end
    end
  end
end
