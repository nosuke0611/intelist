class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(following followers)

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.page(params[:page]).per(20)
  end

  def following
    @user  = User.find(params[:id])
    @title = "#{@user.name}のフォロー"
    @users = @user.following
    @controller_name = 'フォロー'
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @title = "#{@user.name}のフォロワー"
    @users = @user.followers
    @controller_name = 'フォロワー'
    render 'show_follow'
  end
end
