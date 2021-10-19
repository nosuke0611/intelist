require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:user) { create(:user) }
  let(:other_user1) { create(:user) }
  let(:other_user2) { create(:user) }
  let(:relationship) { user.active_relationships.create(followed_id: other_user1.id) }
  before(:each) do
    sign_in user
  end
  describe 'Post/ create' do
    context 'ユーザーをフォローした場合' do
      it 'フォローしたユーザーのフォローが1人増える' do
        follow_params = { followed_id: other_user1.id }
        expect do
          post relationships_path(follow_params)
        end.to change(user.active_relationships, :count).by(1)
      end
      it 'フォローされたユーザーのフォロワーが1人増える' do
        follow_params = { followed_id: other_user1.id }
        expect do
          post relationships_path(follow_params)
        end.to change(other_user1.passive_relationships, :count).by(1)
      end
    end
  end
  describe 'Delete/ destroy' do
    context 'ユーザーのフォローを解除した場合' do
      it 'フォロー解除したユーザーのフォローが1人減る' do
        follow_params = { id: relationship.id }
        expect do
          delete relationship_path(follow_params)
        end.to change(user.active_relationships, :count).by(-1)
      end
      it 'フォロー解除されたユーザーのフォロワーが1人減る' do
        follow_params = { id: relationship.id }
        expect do
          delete relationship_path(follow_params)
        end.to change(other_user1.passive_relationships, :count).by(-1)
      end
    end
  end
end
