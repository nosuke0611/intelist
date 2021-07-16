class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(following followers)

  def index
    @users = User.searched(params[:search]).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @post_count = @user.posts.count
  end

  def following
    @user  = User.find(params[:id])
    @title = "#{@user.name}のフォロー"
    @users = @user.following.page(params[:page]).per(20)
    @controller_name = 'フォロー'
    @post = Post.new
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @title = "#{@user.name}のフォロワー"
    @users = @user.followers.page(params[:page]).per(20)
    @controller_name = 'フォロワー'
    @post = Post.new
    render 'show_follow'
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(20)
    @post = Post.new
  end
end
