require 'rails_helper'

RSpec.describe '投稿機能のテスト', type: :system do
  let(:user) { create(:user) }

  describe 'トップページでの投稿作成処理' do
    before(:each) do 
      sign_in user
    end
  
    context '投稿作成前の場合' do
      it '投稿が存在しない' do
        visit root_path
        expect(page).to have_content '投稿はまだありません'
      end
    end
    # 無効なデータ
    context 'アイテム名が空欄の場合' do
      it '投稿が作成されないこと', js: true do
        visit root_path
        find_by_id('newpost-create-btn').click
        fill_in 'newpost-itemname', with: ''
        fill_in 'newpost-content',  with: 'test-content'
        fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
        find_by_id('post-submit-btn').click
        expect(page).to have_content 'アイテム名は必須です'
      end
    end
    # 正常なデータ
    context 'アイテム名、投稿内容、タグが入力されている場合' do
      it '投稿が作成されること', js: true do
        visit root_path
        expect do
          find_by_id('newpost-create-btn').click
          fill_in 'newpost-itemname', with: 'test-itemname'
          fill_in 'newpost-content',  with: 'test-content'
          fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
          find_by_id('post-submit-btn').click
          expect(page).to have_content 'test-itemname'
        end.to change(Post, :count).by(1)
      end
    end
    context 'アイテム名、タグのみが入力されている場合' do
      it '投稿が作成されること', js: true do
        visit root_path
        expect do
          find_by_id('newpost-create-btn').click
          fill_in 'newpost-itemname', with: 'test-itemname'
          fill_in 'newpost-content',  with: ''
          fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
          find_by_id('post-submit-btn').click
          expect(page).to have_content 'test-itemname'
        end.to change(Post, :count).by(1)
      end
    end
    context 'アイテム名、投稿内容のみが入力されている場合' do
      it '投稿が作成されること', js: true do
        visit root_path
        expect do
          find_by_id('newpost-create-btn').click
          fill_in 'newpost-itemname', with: 'test-itemname'
          fill_in 'newpost-content',  with: 'test-content'
          fill_in 'newpost-tags',     with: ''
          find_by_id('post-submit-btn').click
          expect(page).to have_content 'test-itemname'
        end.to change(Post, :count).by(1)
      end
    end
  end
end
