require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Userモデルの登録処理' do
    let(:user) { build(:user) }
    context 'バリデーションを通過するケース' do
      it '有効な情報でであれば正常に登録される' do
        expect(user).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'nameがnilの場合は無効になる' do
        user.name = nil
        user.valid?
        expect(user.errors[:name]).to include(':ユーザー名が入力されていません')
      end
      it 'nameが30文字を超えた場合は無効になる' do
        user.name = 'a' * 31
        expect(user).to be_invalid
      end
      it 'emailがnilの場合は無効になる' do
        user.email = nil
        user.valid?
        expect(user.errors[:email]).to include(':メールアドレスが入力されていません')
      end
      it 'emailが255文字を超えた場合は無効になる' do
        user.email = 'a' * 244 + 'example.com'
        expect(user).to be_invalid
      end
      it 'emailが既存ユーザーと重複している場合無効になる' do
        dup_user = user.dup
        user.save
        expect(dup_user).to be_invalid
      end
      it 'emailは大文字と小文字を区別せず、同じ文字列の場合は無効になる' do
        dup_user = user.dup
        dup_user.email = user.email.upcase
        user.save
        expect(dup_user).to be_invalid
      end
      it 'passwordが8文字未満の場合は無効になる' do
        user.password = user.password_confirmation = 'a' * 5
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
        search_params = { user_name: 'テスト' }
        expect(User.searched(search_params)).to include(user)
        expect(User.searched(search_params)).not_to include(other_users)
      end
    end
    context 'どのユーザー名とも合致しない文字列で検索した場合' do
      it '空のコレクションを返す' do
        search_params = { user_name: 'BLANK' }
        expect(User.searched(search_params)).to be_empty
      end
    end
  end
end
