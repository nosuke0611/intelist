require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Postモデルのバリデーション確認' do
    context 'バリデーションを通過するケース' do
      it 'ユーザー、アイテム、投稿内容、タグがある場合は正常に登録できる' do
        expect(build(:post)).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'ユーザーがいない場合は投稿が作成できない' do
        expect(build(:post, user: nil)).to be_invalid
      end
      it 'アイテムがない場合は投稿が作成できない' do
        expect(build(:post, item: nil)).to be_invalid
      end
      it '同一ユーザーが同じアイテムについて二度目の投稿はできない' do
        same_user = create(:user, id: 1)
        same_item = create(:item, id: 1, item_name: 'same-name')
        create(:post, user: same_user, item: same_item)
        expect(build(:post, user: same_user, item: same_item)).to be_invalid
      end
    end
  end
  describe 'Postモデルの削除処理' do
    context '投稿したユーザーを削除した場合' do
      it '紐づく投稿も削除される' do
        test_post = create(:post)
        expect { test_post.user.destroy }.to change { Post.count }.by(-1)
      end
    end
  end
  describe '取得範囲限定メソッドの動作確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:unfollowing_public_posts) { create(:post) }
    context 'follow_onlyメソッドを使用した場合' do
      it 'フォローしているユーザーの投稿のみを取得する' do
        user.follow(other_user)
        following_post = create(:post, user: other_user)
        expect(Post.follow_only(user)).to include(following_post)
        expect(Post.follow_only(user)).not_to include(unfollowing_public_posts)
      end
    end
    context 'public_and_byメソッドを使用した場合' do
      it '自分の投稿と公開投稿のみを取得する' do
        self_post = create(:private_post, user: user)
        private_post = create(:private_post, user: other_user)
        expect(Post.public_and_by(user)).to include(self_post, unfollowing_public_posts)
        expect(Post.public_and_by(user)).not_to include(private_post)
      end
    end
  end
  # マイアイテム一覧ページでの検索機能
  describe '検索メソッドの動作確認' do
    let!(:test_user) { create(:user, name: 'テストユーザー') }
    let!(:changed_item_post) { create(:changed_itemname_post, user: test_user) }
    let!(:changed_tag_post) { create(:changed_tagname_post, user: test_user) }
    let!(:completed_post) { create(:completed_post, user: test_user) }
    context 'アイテム名で検索した場合' do
      it '該当するアイテムのみが表示される' do
        search_params = { item_name: 'テスト' }
        expect(Post.searched(search_params)).to include(changed_item_post)
        expect(Post.searched(search_params)).not_to include(changed_tag_post, completed_post)
      end
    end
    context 'タグ名で検索した場合' do
      it '該当するアイテムのみが表示される' do
        search_params = { tag_name: 'テスト' }
        expect(Post.searched(search_params)).to include(changed_tag_post)
        expect(Post.searched(search_params)).not_to include(changed_item_post, completed_post)
      end
    end
    context '完了済のみを検索した場合' do
      it '該当するアイテムのみが表示される' do
        search_params = { status: 'completed' }
        expect(Post.searched(search_params)).to include(completed_post)
        expect(Post.searched(search_params)).not_to include(changed_item_post, changed_tag_post)
      end
    end
    context '未完了のみを検索した場合' do
      it '該当するアイテムのみが表示される' do
        search_params = { status: 'uncompleted' }
        expect(Post.searched(search_params)).to include(changed_item_post, changed_tag_post)
        expect(Post.searched(search_params)).not_to include(completed_post)
      end
    end
    context '複数条件で検索した場合' do
      it 'AND検索として該当するアイテムのみが表示される' do
        search_params = { status: 'completed', item_name: '完了済み' }
        expect(Post.searched(search_params)).not_to include(completed_post)
        expect(Post.searched(search_params)).not_to include(changed_item_post, changed_tag_post)
      end
    end
    context '該当したい条件で検索した場合' do
      it '空のコレクションを返す' do
        search_params = { status: 'uncompleted', item_name: '完了済み' }
        expect(Post.searched(search_params)).to be_empty
      end
    end
  end
end
