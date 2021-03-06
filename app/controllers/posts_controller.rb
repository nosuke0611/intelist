class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: %i[create show]

  def create
    @post = current_user.posts.build(post_params)
    @post.item_id = Item.find_or_create_by(item_name: params[:post][:item_name]).id
    if @post.save
      @post.save_tags(params[:post][:tag_name].split(/,|\s/))
      @post.create_thumbnails
      flash[:notice] = '投稿に成功しました'
    else
      flash[:alert] = '投稿に失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def show
    @post = Post.includes([:user, { comments: [:user], likes: [:user] }]).find(params[:id])
    return unless @post.private == true

    if @post.user == current_user
      @post
    else
      flash[:alert] = '投稿は非公開です'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @post.item_id = Item.find_or_create_by(item_name: params[:post][:item_name]).id
    if @post.update(post_params)
      @post.save_tags(params[:post][:tag_name].split(/,|\s/))
      @post.create_thumbnails
      flash[:notice] = '投稿を編集しました'
    else
      flash[:alert] = '投稿の編集に失敗しました'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if @post.destroy
      flash[:notice] = '投稿を削除しました'
      if request.referer&.include?('posts')
        redirect_to root_path
      else
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:alert] = '投稿の削除に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def complete
    @post.complete
    redirect_back(fallback_location: post_url(@post))
  end

  def uncomplete
    @post.uncomplete
    redirect_back(fallback_location: post_url(@post))
  end

  private

    def post_params
      params.require(:post).permit(:content, :url, :private)
    end

    def correct_user
      if action_name == 'complete' || action_name == 'uncomplete'
        @post = current_user.posts.find_by(id: params[:post_id])
      end
      @post = current_user.posts.find_by(id: params[:id]) if action_name == 'update' || action_name == 'destroy'
      redirect_back(fallback_location: root_path) if @post.nil?
    end
end
