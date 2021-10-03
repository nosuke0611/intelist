class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_params = item_search_params
    @base_items = Item.searched(@search_params).unscope(:order).distinct
    @items = @base_items.page(params[:page]).per(20).order("#{items_sort_column} #{items_sort_direction}")
  end
  
  def show
    @item = Item.find(params[:id])
    @tags = @item.tags.uniq
    @users = @item.users.uniq
    @post = Post.new
    @show_posts = @item.posts.includes([:user, :tags, { comments: [:user] }]).page(params[:page]).per(20)
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
    @users = @item.users.uniq
    @related_users = Kaminari.paginate_array(@users).page(params[:page]).per(20)
  end

  def ranking
    @base_items = if params[:follow_status] == 'only_follow'
      Item.joins(:posts).where(posts: { user_id: current_user.following_ids })
                  else
      Item.joins(:posts)
                  end
    case params[:period]
    when 'all'
      @from = 'all'
      @items = @base_items.group(:item_id).order('count(item_id) desc').limit(10)
    when 'monthly'
      @from = Time.current - 30.days
      @items = @base_items.group(:item_id).where('posts.created_at >= ?', @from).order('count(item_id) desc').limit(10)
    else # weekly
      @from = Time.current - 6.days
      @items = @base_items.group(:item_id).where('posts.created_at >= ?', @from).order('count(item_id) desc').limit(10)
    end
  end

  # アイテム一覧ソート用メソッド（デフォルトはid降順）
  def items_sort_column
    Item.column_names.include?(params[:column]) ? params[:column] : 'id'
  end

  # アイテムー一覧ソート方向変更用メソッド
  def items_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  # ソート時に検索条件を引き継ぐためのメソッド
  def take_item_search_params
    { searched: { item_name: @search_params.try(:[], :item_name),
                  tag_name: @search_params.try(:[], :tag_name),
                  user_name: @search_params.try(:[], :user_name) } }
  end

  helper_method :items_sort_column, :items_sort_direction, :take_item_search_params

  private
    def item_params
      params.require(:item).permit(:item_name)
    end

    def item_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :user_name)
    end
end
