class BasicController < ApplicationController
  def home
    if user_signed_in?
      @posts = Post.where(user_id: [current_user.id, *current_user.following_ids]).page(params[:page]).per(20)
    else
      @posts = Post.new
    end
  end
end
