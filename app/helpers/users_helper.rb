module UsersHelper
  def current_user?(user)
    user && user == current_user
  end

  # ユーザー画像を表示。未登録の場合はデフォルト画像
  def show_avatar(user, size = '40x40')
    if user.avatar.blank?
      image_tag(ENV['DEFAULT_AVATAR'], size: size, class: 'icon-mini rounded user-icon')
    else
      image_tag(user.avatar.url, size: size, class: 'icon-mini rounded user-icon')
    end
  end

  # ユーザー一覧画面でのソート機能
  def users_sortable(column, title, hash_params = {})
    title ||= column.titleize
    css_class = users_sort_column.include?(column) ? "current_#{sort_direction}" : nil
    direction = sort_direction == 'desc' ? 'asc' : 'desc'
    link_to title, { column: column, direction: direction }.merge(hash_params), class: "sort_header #{css_class}", 
                                                                                remote: true
  end

  # マイアイテム一覧画面でのソート機能
  def myitems_sortable(column, title, hash_params = {})
    title ||= column.titleize
    css_class = myitems_sort_column.include?(column) ? "current_#{sort_direction}" : nil
    direction = sort_direction == 'desc' ? 'asc' : 'desc'
    link_to title, { column: column, direction: direction }.merge(hash_params), class: "sort_header #{css_class}", 
                                                                                remote: true
  end
end
