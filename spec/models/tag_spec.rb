require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'タグモデルの作成処理' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    context '新たなタグ使用した場合' do
      it '新規のインスタンスが作成される' do
        expect do
          create(:post)
        end.to change { Tag.count }.by(1)
      end
    end
    # 既存タグを使用した場合にインスタンスが再利用されるテストはリクエストスペックで実施
    # Factory_botがfind_or_createの挙動を取れないため
  end
  describe 'タグ検索メソッドの動作確認' do
    let(:tag) { create(:tag, tag_name: 'テストタグ') }
    let(:other_tags) { create_list(:tag, 3) }
    before(:each) do
      tag
      other_tags
    end
    context 'いずれかのタグ名に含まれる文字列で検索した場合' do
      it 'タグ名に検索文字列を含むタグのみを返す' do
        search_params = { tag_name: 'テスト' }
        expect(Tag.searched(search_params)).to include(tag)
        expect(Tag.searched(search_params)).not_to include(other_tags)
      end
    end
    context 'どのタグにも合致しない文字列で検索した場合' do
      it '空のコレクションを返す' do
        search_params = { tag_name: 'BLANK' }
        expect(Tag.searched(search_params)).to be_empty
      end
    end
  end
end
