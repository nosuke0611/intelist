require 'rails_helper'

RSpec.describe '検索機能のテスト', type: :system do
  describe 'ユーザー一覧画面での検索機能テスト', js: true do
    let(:user) { create(:user, name: 'テストユーザー') }
    let(:other_users) { create_list(:user, 3) }
    before(:each) do
      sign_in user
      other_users
    end
    context 'ユーザー名「テスト」で検索すると' do
      it '「TESTUSER]は表示されない' do
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
  describe 'アイテム一覧画面での検索機能テスト', js: true do
    let(:user) { create(:user) }
    let!(:post) { create(:post) }
    let!(:itempost) { create(:changed_itemname_post) }
    let!(:tagpost) { create(:changed_tagname_post) }
    before(:each) do
      sign_in user
    end
    context 'アイテム名で検索すると' do
      it 'アイテム名に対象の文字列を含むアイテムのみ表示される' do
        visit items_path
        fill_in 'search-itemname', with: 'テスト'
        find_by_id('search-submit-btn').click
        expect(page).to have_content 'テストアイテム'
        expect(page).not_to have_content 'TESTITEM'
        find_by_id('search-reset-btn').click
        expect(page).to have_content 'TESTITEM'
      end
    end
    context 'タグ名で検索すると' do
      it '対象の文字列を含むタグと紐づいたアイテムのみが表示される' do
        visit items_path
        fill_in 'search-tagname', with: 'テストタグ'
        find_by_id('search-submit-btn').click
        expect(page).to have_content 'タグ名変更アイテム'
        expect(page).not_to have_content 'TESTITEM'
        expect(page).not_to have_content 'テストアイテム'
        find_by_id('search-reset-btn').click
        expect(page).to have_content 'TESTITEM'
      end
    end
    context 'アイテム名とタグ名で検索すると' do
      it 'どちらの条件も満たすアイテムのみが表示される' do
        visit items_path
        fill_in 'search-itemname', with: 'アイテム'
        fill_in 'search-tagname', with: 'テスト'
        find_by_id('search-submit-btn').click
        expect(page).to have_content 'タグ名変更アイテム'
        expect(page).not_to have_content 'TESTITEM'
        expect(page).not_to have_content 'テストアイテム'
        find_by_id('search-reset-btn').click
        expect(page).to have_content 'TESTITEM'
      end
    end
  end
  describe 'タグ一覧画面での検索機能テスト', js: true do
    let(:user) { create(:user) }
    let!(:post) { create(:post) }
    let!(:tagpost) { create(:changed_tagname_post) }
    before(:each) do
      sign_in user
    end
    context 'タグ名で検索すると' do
      it '対象のタグのみが表示される' do
        visit tags_path
        expect(page).to have_content 'TESTTAG'
        fill_in 'search-tagname', with: 'テストタグ'
        find_by_id('search-submit-btn').click
        within('.main-tag') do
          expect(page).to have_content 'テストタグ'
          expect(page).not_to have_content 'TESTTAG'
        end
        find_by_id('search-reset-btn').click
        within('.main-tag') do
          expect(page).to have_content 'TESTTAG'
        end
      end
    end
  end
end
