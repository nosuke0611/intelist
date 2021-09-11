class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.searched(params[:search]).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @myposts = @user.posts.includes([:tags, { comments: [:user] }]).page(params[:page]).per(20)
    @favposts = Post.all_liked_by(@user).includes([:tags, { comments: [:user] }]).page(params[:page]).per(20) if @myposts.blank?
    @composts = Post.all_commented_by(@user).includes([:tags, { comments: [:user] }]).page(params[:page]).per(20)\
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
    @user_posts = Post.includes(:tags).where(user_id: @user.id)
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

  private
    def post_search_params
      params.fetch(:searched, {}).permit(:item_name, :tag_name, :status)
    end
end
