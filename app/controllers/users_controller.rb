class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(following followers)

  def index
    @users = User.searched(params[:search]).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @myposts = @user.posts.page(params[:page]).per(20)
    @favposts = Post.liked_by_user(@user).page(params[:page]).per(20) unless @myposts.present?
    @composts = Post.commented_by_user(@user).page(params[:page]).per(20) unless @favposts.present?
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
end
