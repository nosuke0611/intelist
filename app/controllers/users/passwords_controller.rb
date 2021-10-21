class Users::PasswordsController < Devise::PasswordsController
  before_action :ensure_normal_user, only: :create

  def ensure_normal_user
    return unless params[:user][:email].downcase == 'guestuser@example.com'

    redirect_to new_user_session_path, alert: 'ゲストユーザーのパスワード再設定はできません。'
  end

  def create
    super
    create_internal
  end

  def create_internal; end

end
