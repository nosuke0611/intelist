require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'タグモデルの作成処理' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    context '新たなタグ使用した場合' do
      it '新規のインスタンスが作成される' do
        expect do
          create(:post)
        end.to change { Tag.count }.by(1)
      end
    end
    # 既存タグを使用した場合にインスタンスが再利用されるテストはリクエストスペックで実施
  end
end
