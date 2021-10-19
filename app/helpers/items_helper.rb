module ItemsHelper
  # アイテム一覧画面でのソート機能
  def items_sortable(column, title, hash_params = {})
    title ||= column.titleize
    css_class = items_sort_column.include?(column) ? "current_#{sort_direction}" : nil
    direction = sort_direction == 'desc' ? 'asc' : 'desc'
    link_to title, { column: column, direction: direction }.merge(hash_params), class: "sort_header #{css_class}", 
                                                                                remote: true
  end
end
