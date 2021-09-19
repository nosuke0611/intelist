require 'rails_helper'

RSpec.describe '投稿機能のテスト', type: :system do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

  before do 
    sign_in(user)
  end

  describe 'トップページでの投稿作成処理' do
    context '投稿作成前' do
      it '投稿が存在しない' do
        visit root_path
        expect(page).to have_content '投稿はまだありません'
      end
    end

    context '無効なデータの時' do
      it 'アイテム名が空欄なら投稿が作成されないこと', js: true do
        visit root_path
        click_on '新規投稿'
        fill_in 'newpost-itemname', with: ''
        fill_in 'newpost-content',  with: 'test-content'
        fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
        click_on '投稿する'
        expect(page).to have_content 'アイテム名は必須です'
      end
    end

    context '正しいデータの時' do
      it 'フルデータの場合は投稿が作成されること', js: true do
        visit root_path
        expect do
          find_by_id('newpost-create-btn').click
          fill_in 'newpost-itemname', with: 'test-itemname'
          fill_in 'newpost-content',  with: 'test-content'
          fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
          find_by_id('post-submit-btn').click
          visit current_path
          expect(page).to have_content 'test-itemname'
        end.to change(Post, :count).by(1)
      end

      it '投稿内容が空欄の場合でも投稿が作成されること', js: true do
        visit root_path
        expect do
          find_by_id('newpost-create-btn').click
          fill_in 'newpost-itemname', with: 'test-itemname'
          fill_in 'newpost-content',  with: ''
          fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
          find_by_id('post-submit-btn').click
          visit current_path
          expect(page).to have_content 'test-itemname'
        end.to change(Post, :count).by(1)
      end

      it 'タグが空欄の場合でも投稿が作成されること', js: true do
        visit root_path
        expect do
          find_by_id('newpost-create-btn').click
          fill_in 'newpost-itemname', with: 'test-itemname'
          fill_in 'newpost-content',  with: 'test-content'
          fill_in 'newpost-tags',     with: ''
          find_by_id('post-submit-btn').click
          visit current_path
          expect(page).to have_content 'test-itemname'
        end.to change(Post, :count).by(1)
      end
    end
  end
end
