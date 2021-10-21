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
    context '無効なデータとして投稿を作成できないケース' do
      it 'アイテム名が空欄の場合は投稿が作成されない', js: true do
        visit root_path
        find_by_id('newpost-create-btn').click
        fill_in 'newpost-itemname', with: ''
        fill_in 'newpost-content',  with: 'test-content'
        fill_in 'newpost-tags',     with: 'test-tag1, test-tag2'
        find_by_id('post-submit-btn').click
        expect(page).to have_content 'アイテム名は必須です'
      end
    end
    context '投稿を正常に作成できるケース' do
      it 'アイテム名、投稿内容、タグが入力されている場合は投稿が作成される', js: true do
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
      it '投稿内容がない場合も投稿が作成される', js: true do
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
      it 'タグが入力されていない場合も投稿が作成される', js: true do
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
  describe 'トップページでの投稿編集テスト' do
    before(:each) do
      sign_in user
      create(:post, user: user)
    end
    context '投稿を正常に編集できるケース' do
      it 'アイテム名を変更した場合問題なく保存できる' do
        visit root_path
        expect do
          find_by_id('post-1-edit-btn').click
          fill_in 'editpost-itemname', with: 'changed-itemname'
          find_by_id('post-edit-btn').click
          expect(page).to have_content 'changed-itemname'
          expect(page).not_to have_content '"TESTITEM-1'
        end
      end
    end
  end
end
