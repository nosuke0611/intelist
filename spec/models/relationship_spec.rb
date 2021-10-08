require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'Relationshipモデルのバリデーション確認' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }
    context 'バリデーションを通過するケース' do
      it 'フォロー、フォロワーともに存在する場合は正常に登録される' do
        expect(relationship).to be_valid
      end
    end
    context 'バリデーションを通過しないケース' do
      it 'フォロワーがnilの場合はリレーションシップを作成できない' do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end
      it 'フォローがnilの場合はリレーションシップを作成できない' do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
  describe 'Relationshipモデルの削除処理' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:relationship) { user.active_relationships.create(followed_id: other_user.id) }
    context 'フォローしている側のユーザーが削除された場合' do
      it 'フォローされていた側のユーザーのフォロワーから削除される' do
        expect { user.destroy }.to change { other_user.passive_relationships.count }.by(-1)
      end
    end
    context 'フォローされている側のユーザーが削除された場合' do
      it 'フォローしている側のユーザーのフォローから削除される' do
        expect { other_user.destroy }.to change { user.active_relationships.count }.by(-1)
      end
    end
  end
end