require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'Relationshipモデルの登録処理' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }

    context 'バリデーションを通過する例' do
      it '正しいデータであれば正常に登録される' do
        expect(relationship).to be_valid
      end
    end

    context 'バリデーションを通過しない例' do
      it "フォロワーIDがnilの場合エラーになる" do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end

      it "フォローIDがnilの場合エラーになる" do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end

  end
end