class BasicController < ApplicationController
  before_action :authenticate_user!, except: :home

  def home
    return unless user_signed_in?

    @following_posts = Post.includes([:tags, :user, :item, { comments: [:user] }])
                           .follow_only(current_user).public_and_by(current_user).page(params[:page]).per(20)
    if @following_posts.blank?
      @all_posts = Post.includes([:tags, :user, :item, { comments: [:user] }])
                       .all.public_and_by(current_user).page(params[:page]).per(20)
    end
    @post = Post.new
  end

  # タイムライン切替用
  def followingtl
    @following_posts = Post.follow_only(current_user).public_and_by(current_user).page(params[:page]).per(20)
    @post = Post.new
  end

  def alltl
    @all_posts = Post.all.public_and_by(current_user).page(params[:page]).per(20)
    @post = Post.new
  end
end
