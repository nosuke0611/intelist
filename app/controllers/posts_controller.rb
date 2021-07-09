class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @item = Item.find_or_create_by(name: params[:post][:item_name])
    @post.item_id = @item.id
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tags(tag_list)
      flash.now[:success] = '投稿に成功しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = '投稿に失敗しました'
      render 'new'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました'
    redirect_back(fallback_location: root_path)
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end
end
