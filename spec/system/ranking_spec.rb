require 'rails_helper'

RSpec.describe 'ランキング機能のテスト', type: :system do
  describe 'ランキング画面での動作テスト', js: true do
    let(:user) { create(:user) }
    let!(:first_item) { create(:item, item_name: 'アイテム1') }
    let!(:second_item) { create(:item, item_name: 'アイテム2') }
    let!(:third_item) { create(:item, item_name: 'アイテム3') }
    let!(:fourth_item) { create(:item, item_name: 'アイテム4') }
    let!(:fifth_item) { create(:item, item_name: 'アイテム5') }
    let!(:sixth_item) { create(:item, item_name: 'アイテム6') }
    before(:each) do
      sign_in user
      create_list(:post, 6, item: first_item, created_at: Time.current)
      create_list(:post, 5, item: second_item, created_at: Time.current)
      create_list(:post, 4, item: third_item, created_at: Time.current - 10.days)
      create_list(:post, 3, item: fourth_item, created_at: Time.current - 10.days)
      create_list(:post, 2, item: fifth_item, created_at: Time.current - 40.days)
      create_list(:post, 1, item: sixth_item, created_at: Time.current - 40.days)
    end
    context '全ユーザー/週間を選択した場合' do
      it '絞り込み条件に合致するアイテムがランキング表示される' do
        visit ranking_path
        wait_for_css_appear('.items-area')
        within('.ranking-search-area') do
          find('#all-user-search').click
          find('#weekly-search').click
          click_on '変更'
        end
        wait_for_ajax
        expect(page).to have_content 'アイテム2'
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).not_to have_content 'アイテム3'
        expect(items_list[3]).not_to have_content 'アイテム4'
        expect(items_list[4]).not_to have_content 'アイテム5'
        expect(items_list[5]).not_to have_content 'アイテム6'
      end
    end
    context '全ユーザー/月間を選択した場合' do
      it '絞り込み条件に合致するアイテムがランキング表示される' do
        visit ranking_path
        wait_for_css_appear('.items-area')
        within('.ranking-search-area') do
          find('#all-user-search').click
          find('#monthly-search').click
          click_on '変更'
        end
        wait_for_ajax
        expect(page).to have_content 'アイテム4'
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).to have_content 'アイテム3'
        expect(items_list[3]).to have_content 'アイテム4'
        expect(items_list[4]).not_to have_content 'アイテム5'
        expect(items_list[5]).not_to have_content 'アイテム6'
      end
    end
    context '全ユーザー/全期間を選択した場合' do
      it '絞り込み条件に合致するアイテムがランキング表示される' do
        visit ranking_path
        wait_for_css_appear('.items-area')
        within('.ranking-search-area') do
          find('#all-user-search').click
          find('#all-period-search').click
          click_on '変更'
        end
        wait_for_ajax
        expect(page).to have_content 'アイテム6'
        items_list = all('.item-list')
        expect(items_list[0]).to have_content 'アイテム1'
        expect(items_list[1]).to have_content 'アイテム2'
        expect(items_list[2]).to have_content 'アイテム3'
        expect(items_list[3]).to have_content 'アイテム4'
        expect(items_list[4]).to have_content 'アイテム5'
        expect(items_list[5]).to have_content 'アイテム6'
      end
    end
  end
end
