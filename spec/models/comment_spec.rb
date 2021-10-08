require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Commentモデルのバリデーション確認' do
    context 'バリデーションを通過するケース' do
      it 'コメント内容がある場合は正常に登録できる' do
        expect(build(:comment)).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'ユーザーがいない場合はコメントが作成できない' do
        expect(build(:comment, user: nil)).to be_invalid
      end
      it '投稿がない場合はコメントが作成できない' do
        expect(build(:comment, post: nil)).to be_invalid
      end
      it 'コメント内容がない場合はコメントが作成できない' do
        expect(build(:comment, comment: nil)).to be_invalid
      end
    end
  end
  describe 'Commentモデルの削除処理' do
    context 'コメントしたユーザーを削除した場合' do
      it '紐づくコメントも削除される' do
        test_comment = create(:comment)
        expect { test_comment.user.destroy }.to change { Comment.count }.by(-1)
      end
    end
    context 'コメントした投稿を削除した場合' do
      it '紐づくコメントも削除される' do
        test_comment = create(:comment)
        expect { test_comment.post.destroy }.to change { Comment.count }.by(-1)
      end
    end
  end
end
