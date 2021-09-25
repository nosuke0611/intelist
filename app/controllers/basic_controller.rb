class BasicController < ApplicationController
  before_action :authenticate_user!, except: :home
  
  def home  
    if user_signed_in?
      @following_posts = Post.includes([:tags, :user, :item,
                                        { comments: [:user] }]).where(user_id: [current_user.id, *current_user.following_ids]).page(params[:page]).per(20)
      @all_posts = Post.includes([:tags, :user, :item, { comments: [:user] }]).all.page(params[:page]).per(20) if @following_posts.blank?
      @post = Post.new
    else
      @posts = Post.new
      @post = Post.new
    end
  end

  # タイムライン切替用
  def followingtl
    @following_posts = Post.where(user_id: [current_user.id, *current_user.following_ids]).page(params[:page]).per(20)
    @post = Post.new 
  end

  def alltl
    @all_posts = Post.all.page(params[:page]).per(20)
    @post = Post.new
  end
end
