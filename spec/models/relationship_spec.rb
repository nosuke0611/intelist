require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'バリデーションの確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }

    it '正常なテストデータで正しくRelationshipが出来上がる' do
      expect(relationship).to be_valid
    end

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