module UsersHelper
  def current_user?(user)
    user && user == current_user
  end

  # ユーザー画像が登録されていない場合のデフォルト画像を表示
  def show_avatar(user, size = '40x40')
    if user.avatar.blank?
      image_tag(ENV['DEFAULT_AVATAR'], size: size, class: 'icon-mini rounded user-icon')
    else
      image_tag(user.avatar.url, size: size, class: 'icon-mini roundet user-icon')
    end
  end
end
