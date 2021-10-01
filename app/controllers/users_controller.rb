class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user_search_params = user_search_params
    @users = User.searched(@user_search_params).page(params[:page]).per(20).order("#{sort_column} #{sort_direction}")
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @myposts = @user.posts.includes([:tags, :item, { comments: [:user] }]).page(params[:page]).per(20)
    @favposts = Post.all_liked_by(@user).includes([:tags, :item, { comments: [:user] }]).page(params[:page]).per(20) if @myposts.blank?
    @composts = Post.all_commented_by(@user).includes([:tags, :item, { comments: [:user] }]).page(params[:page]).per(20)\
      if (@myposts.blank? && @favposts.blank?) 
  end

  # マイページフォロー/フォロワー表示
  def relationships
    @user = User.find(params[:id])
    @post = Post.new
    if params[:link_name] == 'followers'
      @followers_users = @user.followers.page(params[:page]).per(20)
    else
      @following_users = @user.following.page(params[:page]).per(20)
    end
  end

  def following
    @user  = User.find(params[:id])
    @post = Post.new
    @following_users = @user.following.page(params[:page]).per(20) 
  end

  def followers
    @user  = User.find(params[:id])
    @post = Post.new
    @followers_users = @user.followers.page(params[:page]).per(20) 
  end

  # マイページ投稿表示切替用
  def myposts
    @user = User.find(params[:id])
    @myposts = @user.posts.includes([:tags, { comments: [:user] }]).page(params[:page]).per(20)
    @post = Post.new
  end

  def favposts
    @user = User.find(params[:id])
    @favposts = Post.includes([:tags, { comments: [:user] }]).all_liked_by(@user).page(params[:page]).per(20)
    @post = Post.new
  end

  def composts
    @user = User.find(params[:id])
    @composts = Post.includes([:tags, { comments: [:user] }]).all_commented_by(@user).page(params[:page]).per(20)
    @post = Post.new
  end

  # マイアイテム
  def myitems
    @user = User.find(params[:id])
    @user_posts = Post.includes(:tags, :item).where(user_id: @user.id)
    @post = Post.new
    if params[:tag_name]
      tag_name = params[:tag_name]
      @search_params = { searched: { tag_name: tag_name } }
      @posts = @user_posts.searched(@search_params).page(params[:page]).per(20)
    else
      @search_params = post_search_params
      @posts = @user_posts.searched(@search_params).page(params[:page]).per(20)
    end
  end

  # ソート用メソッド（デフォルトはid降順）
  def sort_column
    User.column_names.include?(params[:column]) ? params[:column] : 'id'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
  
  # ソート時に検索条件を引き継ぐためのメソッド
  def take_user_search_params
    { searched: {
        user_name: @user_search_params.try(:[], :user_name),
    }}
  end
  
  helper_method :sort_column, :sort_direction, :take_user_search_params

  private
    def post_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :status)
    end

    def user_search_params
      params.fetch(:searched, {}).permit(:user_name)
    end
end
