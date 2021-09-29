require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Userモデルの登録処理' do
    let(:user) { build(:user) }

    context 'バリデーションを通過する例' do
      it '有効な情報でであれば正常に登録される' do
        expect(user).to be_valid
      end
    end

    context 'バリデーションを通過しない例' do
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

    before(:each) do
      user.follow(other_user)
    end

    context 'userがother_userのフォローに成功した場合' do
      it 'userのフォローにother_userが存在する' do
        expect(user.following?(other_user)).to be_truthy
      end
      it 'otehr_userのフォロワーにuserが存在する' do
        expect(other_user.followers.include?(user)).to be_truthy
      end
    end

    context 'userがother_userのフォロー解除に成功した場合' do
      it 'userのフォローからother_userが消える' do
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsy
      end
      it 'other_userのフォロワーからuserが消える' do
        user.unfollow(other_user)
        expect(other_user.followers.include?(user)).to be_falsy
      end
    end
  end

  describe 'ユーザー検索メソッドの動作確認' do
    let(:user) { create(:user, name: 'テストユーザー') }
    let(:other_users) { create_list(:user, 3) }
    before(:each) do
      user
      other_users
    end

    context 'いずれかのユーザー名に含まれる文字列で検索した場合' do
      it 'ユーザー名に検索文字列を含むユーザーのみを返す' do
        expect(User.searched('テスト')).to include(user)
        expect(User.searched('テスト')).not_to include(other_users)
      end
    end
    context 'どのユーザー名とも合致しない文字列で検索した場合' do
      it '空のコレクションを返す' do
        expect(User.searched('BLANK')).to be_empty
      end
    end
  end
end
