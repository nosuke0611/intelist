require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'Relationshipモデルのバリデーション確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }

    # バリデーションを通過する例
    context 'フォロー、フォロワーが正しく存在する場合' do
      it '正常に登録される' do
        expect(relationship).to be_valid
      end
    end

    # バリデーションを通過しない例
    context 'フォロワーIDがnilの場合' do
      it 'リレーションシップを作成できない' do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end
    end

    context ' フォローIDがnilの場合' do
      it 'リレーションシップを作成できない' do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
end