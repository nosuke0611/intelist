class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user_search_params = user_search_params
    @users = User.searched(@user_search_params).page(params[:page]).per(20).order("#{users_sort_column} #{users_sort_direction}")
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
    @user_posts = Post.includes(%i[tags post_tag_maps item]).where(user_id: @user.id)
    @post = Post.new
    @search_params = post_search_params
    @posts = @user_posts.searched(@search_params).page(params[:page]).per(20).reorder("#{myitems_sort_column} #{myitems_sort_direction}")
  end

  # ユーザー一覧ソート用メソッド（デフォルトはid降順）
  def users_sort_column
    User.column_names.include?(params[:column]) ? params[:column] : 'id'
  end

  # ユーザー一覧ソート方向変更用メソッド
  def users_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
  
  # マイアイテム一覧ソート用メソッド（デフォルトはid降順）
  def myitems_sort_column
    if Post.column_names.include?(params[:column])
      "posts.#{params[:column]}"
    elsif Item.column_names.include?(params[:column])
      "items.#{params[:column]}"
    else
      'posts.created_at'
    end
  end

  # マイアイテム一覧ソート方向変更用メソッド
  def myitems_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # ソート時に検索条件を引き継ぐためのメソッド
  def take_user_search_params
    { searched: { user_name: @user_search_params.try(:[], :user_name),
                  item_name: @search_params.try(:[], :item_name),
                  tag_name: @search_params.try(:[], :tag_name),
                  status: @search_params.try(:[], :status) } }
  end

  helper_method :users_sort_column, :users_sort_direction, :myitems_sort_column, :myitems_sort_direction, :take_user_search_params

  private
    def post_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :status)
    end

    def user_search_params
      params.fetch(:searched, {}).permit(:user_name)
    end
end
