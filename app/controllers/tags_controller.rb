class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_params = tag_search_params
    @all_tags = Tag.joins(:post_tag_maps).group(:tag_id)
    @tags = @all_tags.searched(@search_params).page(params[:page]).per(40)
                     .order("#{tags_sort_column} #{sort_direction}")
  end

  # タグ一覧ソート用メソッド（デフォルトは投稿数降順）
  def tags_sort_column
    if Tag.column_names.include?(params[:column])
      "tags.#{params[:column]}"
    else
      'count(post_id)'
    end
  end

  helper_method :tags_sort_column

  private

    def tag_search_params
      params.fetch(:searched, {}).permit(:tag_name)
    end
end
