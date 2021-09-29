require 'rails_helper'
require 'database_cleaner/active_record'

RSpec.describe '検索機能のテスト', type: :system do
  let(:user) { create(:user) }
  let(:other_users) { create_list(:user, 10) }
  
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

    describe 'アイテム一覧画面での検索機能テスト', js: true do
      let(:items) { create_list(:item, 3) }
      DatabaseCleaner.strategy = :truncation
      before(:each) do
        DatabaseCleaner.start
        sign_in user
        itemslist = items
        3.times do |i|
          user.posts.create(
            item_id: itemslist.find(i + 1)
          )
        end
        itemslist.first.update(item_name: 'テストアイテム')
      end
      context 'アイテム名「テスト」で検索すると' do
        it '「テストアイテム」のみ表示される' do
          visit items_path
          fill_in 'search-itemname', with: 'テスト'
          find_by_id('search-submit-btn').click
          expect(page).to have_content 'テストアイテム'
          expect(page).not_to have_content 'TESTITEM'
          find_by_id('search-reset-btn').click
          expect(page).to have_content 'TESTITEM'
        end
      end
      context 'アイテム名「TEST」で検索すると' do
        it '「テストアイテム」は表示されない' do
          visit items_path
          fill_in 'search-itemname', with: 'TEST'
          find_by_id('search-submit-btn').click
          expect(page).not_to have_content 'テストアイテム'
          expect(page).to have_content 'TESTITEM'
          find_by_id('search-reset-btn').click
          expect(page).to have_content 'テストアイテム'
        end
      end

      after(:each) do
        DatabaseCleaner.clean
      end
    end
  end
end
