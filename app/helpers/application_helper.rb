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
end
