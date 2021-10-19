require 'rails_helper'

RSpec.describe 'ソート機能のテスト', type: :system do
  describe 'ユーザー一覧画面でのソート機能テスト', js: true do
    let!(:first_user) { create(:user, name: 'ユーザー1') }
    let!(:second_user) { create(:user, name: 'ユーザー2') }
    let!(:third_user) { create(:user, name: 'ユーザー3') }
    let(:tenth_user) { create(:user, name: 'ユーザー10') }
    before(:each) do
      sign_in first_user
    end
    context '列名「ユーザー名」をクリックした場合' do
      it 'ユーザー名昇順でソートされる' do
        visit users_path
        wait_for_css_appear('.users-area')
        within('thead') { click_on 'ユーザー名' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー3'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー1'
        expect(users_list[1]).to have_content 'ユーザー2'
        expect(users_list[2]).to have_content 'ユーザー3'
      end
    end
    context '列名「投稿数」をクリックした場合' do
      it '投稿数昇順でソートされる' do
        create_list(:post, 1, user: second_user)
        create_list(:post, 2, user: third_user)
        visit users_path
        wait_for_css_appear('.users-area')
        within('thead') { click_on '投稿数' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー3'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー1'
        expect(users_list[1]).to have_content 'ユーザー2'
        expect(users_list[2]).to have_content 'ユーザー3'
      end
    end
    context '列名「フォロー数」をクリックした場合' do
      it 'フォロー数昇順でソートされる' do
        first_user.active_relationships.create(followed_id: second_user.id)
        first_user.active_relationships.create(followed_id: third_user.id)
        second_user.active_relationships.create(followed_id: third_user.id)
        visit users_path
        wait_for_css_appear('.users-area')
        within('thead') { click_on 'フォロー数' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー3'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー3'
        expect(users_list[1]).to have_content 'ユーザー2'
        expect(users_list[2]).to have_content 'ユーザー1'
      end
    end
    context '列名「フォロワー数」をクリックした場合' do
      it 'フォロワー数昇順でソートされる' do
        first_user.active_relationships.create(followed_id: second_user.id)
        first_user.active_relationships.create(followed_id: third_user.id)
        second_user.active_relationships.create(followed_id: third_user.id)
        visit users_path
        wait_for_css_appear('.users-area')
        within('thead') { click_on 'フォロワー数' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー3'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー1'
        expect(users_list[1]).to have_content 'ユーザー2'
        expect(users_list[2]).to have_content 'ユーザー3'
      end
    end
    context '列名を複数回クリックした場合' do
      it '昇順/降順が切り替わる' do
        visit users_path
        wait_for_css_appear('.users-area')
        within('thead') { click_on 'ユーザー名' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー3'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー1'
        expect(users_list[1]).to have_content 'ユーザー2'
        expect(users_list[2]).to have_content 'ユーザー3'
        within('thead') { click_on 'ユーザー名' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー1'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー3'
        expect(users_list[1]).to have_content 'ユーザー2'
        expect(users_list[2]).to have_content 'ユーザー1'
      end
    end
    context '検索後にソートを行った場合' do
      it '検索結果を引き継いでソートする' do
        tenth_user
        visit users_path
        wait_for_css_appear('.users-area')
        fill_in 'search-username', with: '1'
        find_by_id('search-submit-btn').click
        expect(page).to have_content 'ユーザー1'
        expect(page).to have_content 'ユーザー10'
        expect(page).not_to have_content 'ユーザー2'
        expect(page).not_to have_content 'ユーザー3'
        within('thead') { click_on 'ユーザー名' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー10'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー1'
        expect(users_list[1]).to have_content 'ユーザー10'
        expect(page).not_to have_content 'ユーザー2'
        expect(page).not_to have_content 'ユーザー3'
        within('thead') { click_on 'ユーザー名' }
        wait_for_ajax do
          expect(page).to have_content 'ユーザー1'
        end
        users_list = all('.user-list')
        expect(users_list[0]).to have_content 'ユーザー10'
        expect(users_list[1]).to have_content 'ユーザー1'
        expect(page).not_to have_content 'ユーザー2'
        expect(page).not_to have_content 'ユーザー3'
      end
    end
  end
end
