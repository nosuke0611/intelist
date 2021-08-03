class ItemsController < ApplicationController
  
  def index
    if params[:tag_name]
      tag_name = params[:tag_name]
      @search_params = { searched: { tag_name: tag_name } }
      @items = Item.searched(@search_params).page(params[:page]).per(20)
    else
      @search_params = item_search_params
      @items = Item.searched(@search_params).page(params[:page]).per(20)
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @tags = @item.tags.uniq
    @users = @item.users.uniq
    @post = Post.new
    @posts = @item.posts.page(params[:page]).per(20)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash.now[:success] = 'アイテム作成に成功しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = 'アイテム作成に失敗しました'
      render 'new'
    end
  end

  def weekly_ranking
    @from = Time.current - 6.day
    @weekly_items = Item.joins(:posts).group(:item_id).where('posts.created_at >= ?', @from).order('count(item_id) desc').limit(10)
  end

  def monthly_ranking
    @from = Time.current - 30.day
    @monthly_items = Item.joins(:posts).group(:item_id).where('posts.created_at >= ?', @from).order('count(item_id) desc').limit(10)
  end

  def all_ranking
    @from = 'all'
    @all_items = Item.joins(:posts).group(:item_id).order('count(item_id) desc').limit(10)
  end

  private
    def item_params
      params.require(:item).permit(:item_name)
    end

    def item_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :user_name)
    end
end
