class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tag_search_params = tag_search_params
    @all_tags = Tag.joins(:post_tag_maps).group(:tag_id)
    @tags = @all_tags.searched(@tag_search_params).page(params[:page]).per(40).order("#{tags_sort_column} #{tags_sort_direction}")
  end

  # タグ一覧ソート用メソッド（デフォルトは投稿数降順）
  def tags_sort_column
    if Tag.column_names.include?(params[:column])
      "tags.#{params[:column]}"
    else
      'count(post_id)'
    end
  end

  # タグ一覧ソート方向変更用メソッド
  def tags_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # ソート時に検索条件を引き継ぐためのメソッド
  def take_tag_search_params
    { searched: { tag_name: @tag_search_params.try(:[], :tag_name) } }
  end

  helper_method :tags_sort_column, :tags_sort_direction, :take_tag_search_params

  private

  def tag_search_params
    params.fetch(:searched, {}).permit(:tag_name)
  end
end
