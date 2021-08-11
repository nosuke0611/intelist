module ApplicationHelper
  # ページごとのタイトル定義(INTELISTを足す)
  def full_title(page_title = '')
    base_title = 'INTELIST'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  # ユーザー画像が登録されていない場合のデフォルト画像を表示
  def default_avatar
    image_tag(ENV['DEFAULT_AVATAR'], class: 'rounded')
  end
end
