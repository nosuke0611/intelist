class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(following followers)

  def index
    @users = User.searched(params[:search]).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @myposts = @user.posts.page(params[:page]).per(20)
    @favposts = Post.liked_by_user(@user).page(params[:page]).per(20) if @myposts.blank?
    @composts = Post.commented_by_user(@user).page(params[:page]).per(20) if (@myposts.blank? && @favposts.blank?) 
  end

  # フォロー/フォロワー表示
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

  # 投稿表示切替用
  def myposts
    @user = User.find(params[:id])
    @myposts = @user.posts.page(params[:page]).per(20)
    @post = Post.new
  end

  def favposts
    @user = User.find(params[:id])
    @favposts = Post.liked_by_user(@user).page(params[:page]).per(20)
    @post = Post.new
  end

  def composts
    @user = User.find(params[:id])
    @composts = Post.commented_by_user(@user).page(params[:page]).per(20)
    @post = Post.new
  end

  # マイアイテム
  def items
    @user = User.find(params[:id])
    @items = Item.has_user(@user.name).page(params[:page]).per(20)
  end
end
