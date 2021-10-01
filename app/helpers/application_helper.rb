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
  def sortable(column, title, hash_params = {})
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == 'desc') ? 'asc' : 'desc'
    link_to title, { column: column, direction: direction }.merge(hash_params)
  end
end
