class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: %i(create show)

  def create
    @post = current_user.posts.build(post_params)
    @item = Item.find_or_create_by(item_name: params[:post][:item_name])
    @post.item_id = @item.id
    tag_list = params[:post][:tag_name].split(/,|\s/)
    if @post.save
      @post.save_tags(tag_list)
      if @post.url
        thumbnails = @post.thumbnail
        @post.update(ref_title: thumbnails[:title], ref_description: thumbnails[:description], ref_image: thumbnails[:image])
      end
      flash.now[:success] = '投稿に成功しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = '投稿に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @item = Item.find_or_create_by(item_name: params[:post][:item_name])
    @post.item_id = @item.id
    tag_list = params[:post][:tag_name].split(/,|\s/)
    if @post.update(post_params)
      @post.save_tags(tag_list)
      flash.now[:success] = '投稿を編集しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = '投稿の編集に失敗しました'
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました'
    redirect_back(fallback_location: root_path)
  end

  def complete
    @post = Post.find(params[:post_id])
    @post.complete
    redirect_back(fallback_location: post_url(@post))
  end

  def uncomplete
    @post = Post.find(params[:post_id])
    @post.uncomplete
    redirect_back(fallback_location: post_url(@post))
  end
  
  private
    def post_params
      params.require(:post).permit(:content, :url)
    end

    def correct_user
      @post = current_user.posts.find(params[:post_id])
      redirect_to root_url if @post.nil?
    end
end
