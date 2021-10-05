class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: :create

  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      @post.create_notification_like!(current_user)
      respond_to :js
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    if @like.destroy
      respond_to :js
    end
  end

  private
    def like_params
      params.permit(:post_id)
    end

    def correct_user
      @like = current_user.likes.find(params[:id])
      redirect_back(follback_location: root_path) if @like.nil?
    end
end
