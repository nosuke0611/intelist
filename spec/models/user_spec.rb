require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションの確認' do
    let(:user) { build(:user) }

    context 'バリデーションを通過する' do
      it '有効な情報でユーザーが有効になる' do
        expect(user).to be_valid
      end
    end

    context 'バリデーションを通過しない' do
      it 'nameがnilの場合無効になる' do
        user.name = nil
        user.valid?
        expect(user.errors[:name]).to include(':ユーザー名が入力されていません')
      end

      it 'emailがnilの場合無効になる' do
        user.email = nil
        user.valid?
        expect(user.errors[:email]).to include(':メールアドレスが入力されていません')
      end

      it 'nameが30文字を超えると無効になる' do
        user.name = 'a' * 31
        expect(user).to be_invalid
      end

      it 'emailが255文字を超えると無効になる' do
        user.email = 'a' *244 + 'example.com'
        expect(user).to be_invalid
      end
    end
  end
  
  describe 'フォロー関連メソッドの動作確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { user.follow(other_user) }

    describe 'フォロー機能' do
      it 'userのフォローにother_userが存在する' do
        expect(user.following?(other_user)).to be_truthy
      end
      it 'otehr_userのフォロワーにuserが存在する' do
        expect(other_user.followers.include?(user)).to be_truthy
      end
    end

    describe 'フォロー解除機能' do
      it 'フォロー解除が成功し、userのフォローからother_userが消える' do
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsy
      end
      it 'フォロー解除が成功し、other_userのフォロワーからuserが消える' do
        user.unfollow(other_user)
        expect(other_user.followers.include?(user)).to be_falsy
      end
    end
  end
end
