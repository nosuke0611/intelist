require 'rails_helper'

RSpec.describe 'ソート機能のテスト', type: :system do
  describe 'アイテム一覧画面でのソート機能テスト', js: true do
    let(:user) { create(:user) }
    let!(:first_item) { create(:item, item_name: 'アイテム1') }
    let!(:second_item) { create(:item, item_name: 'アイテム2') }
    let!(:third_item) { create(:item, item_name: 'アイテム3') }
    let(:tenth_item) { create(:item, item_name: 'アイテム10') }
    before(:each) do
      sign_in user
    end
    context '列名「アイテム名」をクリックした場合' do
      it 'アイテム名昇順でソートされる' do
        visit items_path
        wait_for_css_appear('.items-area')
        within('thead') { click_on 'アイテム名' }
        wait_for_ajax do
          expect(page).to have_content 'アイテム3'
        end
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).to have_content 'アイテム3'
      end
    end
    context '列名「投稿数」をクリックした場合' do
      it '投稿数昇順でソートされる' do
        create(:post, item: second_item)
        create_list(:post, 2, item: third_item)
        visit items_path
        wait_for_css_appear('.items-area')
        within('thead') { click_on '投稿数' }
        wait_for_ajax do
          expect(page).to have_content 'アイテム3'
        end
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).to have_content 'アイテム3'
      end
    end
    context '列名を複数回クリックした場合' do
      it '昇順/降順が切り替わる' do
        visit items_path
        wait_for_css_appear('.items-area')
        within('thead') { click_on 'アイテム名' }
        wait_for_ajax do
          expect(page).to have_content 'アイテム3'
        end
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).to have_content 'アイテム3'
        within('thead') { click_on 'アイテム名' }
        wait_for_ajax do
          expect(page).to have_content 'アイテム1'
        end
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム3'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).to have_content 'アイテム1'
      end
    end
    context '検索後にソートを行った場合' do
      it '検索結果を引き継いでソートする' do
        tenth_item
        visit items_path
        wait_for_css_appear('.items-area')
        fill_in 'search-itemname', with: '1'
        find_by_id('search-submit-btn').click
        expect(page).to have_content 'アイテム1'
        expect(page).to have_content 'アイテム10'
        expect(page).not_to have_content 'アイテム2'
        expect(page).not_to have_content 'アイテム3'
        within('thead') { click_on 'アイテム名' }
        wait_for_ajax do
          expect(page).to have_content 'アイテム10'
        end
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム10'
        expect(page).not_to have_content 'アイテム2'
        expect(page).not_to have_content 'アイテム3'
        within('thead') { click_on 'アイテム名' }
        wait_for_ajax do
          expect(page).to have_content 'アイテム1'
        end
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム10'
        expect(items_list[1]).to have_content 'アイテム1'
        expect(page).not_to have_content 'アイテム2'
        expect(page).not_to have_content 'アイテム3'
      end
    end
  end
end
