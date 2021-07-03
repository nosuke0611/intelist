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

  # Gravatarの画像をデフォルトのプロフィール画像にする(追々UPできるように修正予定)
  def gravatar_for(user, options = { size: 80 })
    size         = options[:size]
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
