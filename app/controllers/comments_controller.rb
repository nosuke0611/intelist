class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: :create
  
  def create
    @comment = Comment.new(comment_params)
    @post = @comment.post
    if @comment.save
      @post.create_notification_comment!(current_user, @comment.id)
      respond_to :js
    else
      flash[:alert] = 'コメントに失敗しました'
      redirect_to request.referer
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    if @comment.destroy
      respond_to :js
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
      @comment = current_user.comments.find(params[:id])
      redirect_back(follback_location: root_path) if @comment.nil?
    end
end
