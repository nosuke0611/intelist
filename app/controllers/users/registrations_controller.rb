class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i(update destroy)

  def ensure_normal_user
    if resource.email == 'guestuser@example.com'
      redirect_to root_path, alert: 'ゲストユーザーは更新・削除できません'
    end
  end

  protected
    # パスワード入力なしで自身のユーザー情報を変更可能に
    def update_resource(resource, params)
      resource.update_without_current_password(params)
    end

end