class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(following followers)

  def show
    @user = User.find(params[:id])
    @post_count = @user.posts.count
  end

  def index
    @users = User.page(params[:page]).per(20)
  end

  def following
    @user  = User.find(params[:id])
    @post_count = @user.posts.count
    @title = "#{@user.name}のフォロー"
    @users = @user.following
    @controller_name = 'フォロー'
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @post_count = @user.posts.count
    @title = "#{@user.name}のフォロワー"
    @users = @user.followers
    @controller_name = 'フォロワー'
    render 'show_follow'
  end

  def posts
    @user = User.find(params[:id])
    @post_count = @user.posts.count
    @posts = @user.posts.page(params[:page]).per(20)
  end
end
