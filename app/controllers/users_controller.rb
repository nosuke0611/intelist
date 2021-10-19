class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @search_params = user_search_params
    @users = User.searched(@search_params).page(params[:page]).per(20)
                 .order("#{users_sort_column} #{sort_direction}")
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @myposts = @user.posts.includes([:tags, :item, { comments: [:user] }])
                    .public_and_by(current_user).page(params[:page]).per(20)
    return if @myposts.present?

    @favposts = Post.includes([:tags, :item, { comments: [:user] }])
                    .all_liked_by(@user).page(params[:page]).per(20)
    return if @favposts.present?

    @composts = Post.includes([:tags, :item, { comments: [:user] }])
                    .all_commented_by(@user).page(params[:page]).per(20)
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
    @myposts = @user.posts.includes([:tags, { comments: [:user] }])
                    .public_and_by(current_user).page(params[:page]).per(20)
    @post = Post.new
  end

  def favposts
    @user = User.find(params[:id])
    @favposts = Post.includes([:tags, { comments: [:user] }])
                    .all_liked_by(@user).page(params[:page]).per(20)
    @post = Post.new
  end

  def composts
    @user = User.find(params[:id])
    @composts = Post.includes([:tags, { comments: [:user] }])
                    .all_commented_by(@user).page(params[:page]).per(20)
    @post = Post.new
  end

  # マイアイテム
  def myitems
    @user = User.find(params[:id])
    @user_posts = Post.includes(%i[tags post_tag_maps item])
                      .where(user_id: @user.id).public_and_by(current_user)
    @post = Post.new
    @search_params = post_search_params
    @posts = @user_posts.searched(@search_params).page(params[:page]).per(20)
                        .reorder("#{myitems_sort_column} #{sort_direction}")
  end

  # ユーザー一覧ソート用メソッド（デフォルトはid降順）
  def users_sort_column
    User.column_names.include?(params[:column]) ? params[:column] : 'id'
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

  helper_method :users_sort_column, :myitems_sort_column

  private
    def post_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :status)
    end

    def user_search_params
      params.fetch(:searched, {}).permit(:user_name)
    end
end
