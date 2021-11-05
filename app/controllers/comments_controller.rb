class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: :create

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @comment.post.create_notification_comment!(current_user, @comment.id)
    else
      flash[:alert] = 'コメントに失敗しました'
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    else
      flash[:alert] = 'コメントの削除に失敗しました'
      redirect_to request.referer
    end
  end

  private

    def comment_params
      params.required(:comment).permit(:user_id, :post_id, :comment)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_back(fallback_location: root_path) if @comment.nil?
    end
end
