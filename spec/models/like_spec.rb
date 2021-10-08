require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Likeモデルのバリデーション確認' do
    context 'バリデーションを通過するケース' do
      it 'ユーザーと投稿が存在する場合は正常に登録できる' do
        expect(build(:like)).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'ユーザーがいない場合はいいねが作成できない' do
        expect(build(:like, user: nil)).to be_invalid
      end
      it '投稿がない場合はいいねが作成できない' do
        expect(build(:like, post: nil)).to be_invalid
      end
    end
  end
  describe 'Likeモデルの削除処理' do
    context 'いいねしたユーザーを削除した場合' do
      it '紐づくいいねも削除される' do
        test_like = create(:like)
        expect { test_like.user.destroy }.to change { Like.count }.by(-1)
      end
    end
    context 'いいねした投稿を削除した場合' do
      it '紐づくいいねも削除される' do
        test_like = create(:like)
        expect { test_like.post.destroy }.to change { Like.count }.by(-1)
      end
    end
  end
end
