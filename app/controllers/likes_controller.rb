class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: :create

  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      @post.create_notification_like!(current_user)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    else
      flash[:alert] = 'いいねに失敗しました'
      redirect_to request.referer
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    if @like.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    else
      flash[:alert] = 'いいねの削除に失敗しました'
      redirect_to request.referer
    end
  end

  private
    def like_params
      params.permit(:post_id)
    end

    def correct_user
      @like = current_user.likes.find_by(id: params[:id])
      redirect_back(fallback_location: root_path) if @like.nil?
    end
end
