class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_params = item_search_params
    @base_items = Item.searched(@search_params).unscope(:order).distinct
    @items = @base_items.page(params[:page]).per(20)
                        .order("#{items_sort_column} #{sort_direction}")
  end

  def show
    @item = Item.find(params[:id])
    @tags = @item.tags.uniq
    @users = @item.public_users_and(current_user).uniq
    @post = Post.new
    @show_posts = @item.posts.includes([:user, :tags, { comments: [:user] }])
                       .public_and_by(current_user).page(params[:page]).per(20)
  end

  def show_links
    @item = Item.find(params[:id])
    @tags = @item.tags.uniq
    @post = Post.new
    @linked_posts = @item.posts.page(params[:page]).per(20)
    @no_linked_posts_count = @item.posts.where.not(url: nil).count
  end

  def show_users
    @item = Item.find(params[:id])
    @tags = @item.tags.uniq
    @post = Post.new
    @users = @item.public_users_and(current_user).uniq
    @related_users = Kaminari.paginate_array(@users).page(params[:page]).per(20)
  end

  def ranking
    temp_user = params[:follow_status] == 'follow_only' ? current_user : nil
    @items = Item.ranking(temp_user, params[:period])
  end

  # アイテム一覧ソート用メソッド（デフォルトはid降順）
  def items_sort_column
    Item.column_names.include?(params[:column]) ? params[:column] : 'id'
  end

  helper_method :items_sort_column

  private

    def item_params
      params.require(:item).permit(:item_name)
    end

    def item_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :user_name)
    end
end
