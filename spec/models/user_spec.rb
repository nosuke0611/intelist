require 'rails_helper'

RSpec.describe User, type: :model do
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
