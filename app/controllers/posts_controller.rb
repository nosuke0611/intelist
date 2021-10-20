class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: %i[create show]

  def create
    @post = current_user.posts.build(post_params)
    if params[:post][:item_name].present?
      @item = Item.find_or_create_by(item_name: params[:post][:item_name])
      @post.item_id = @item.id
      tag_list = params[:post][:tag_name].split(/,|\s/)
      if @post.save
        @post.save_tags(tag_list)
        @post.create_thumbnails
        flash[:notice] = '投稿に成功しました'
      else
        flash[:alert] = '投稿に失敗しました'
      end
    else
      flash[:alert] = 'アイテム名は必須です' 
    end
    redirect_back(fallback_location: root_path)
  end

  def show
    @post = Post.includes([:user, { comments: [:user], likes: [:user] }]).find(params[:id])
    return if @post.user != current_user 

    return if @post.private != true

    flash[:alert] = '投稿は非公開です'
    redirect_back(fallback_location: root_path)
  end

  def update
    @item = Item.find_or_create_by(item_name: params[:post][:item_name])
    @post.item_id = @item.id
    tag_list = params[:post][:tag_name].split(/,|\s/)
    if @post.update(post_params)
      @post.save_tags(tag_list)
      if @post.url.present?
        thumbnails = @post.thumbnail
        @post.update(ref_title: thumbnails[:title], ref_description: thumbnails[:description], 
                     ref_image: thumbnails[:image])
      end
      flash[:notice] = '投稿を編集しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = '投稿の編集に失敗しました'
      render 'edit'
    end
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
