class ItemsController < ApplicationController
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(item_params)
    tag_list = params[:item][:tag_name].split(nil)
    if @item.save
      @item.save_tags(tag_list)
      flash.now[:success] = 'アイテム作成に成功しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = 'アイテム作成に失敗しました'
      render 'new'
    end
  end

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @item_tags = @item.tags
  end


  private
    def item_params
      params.require(:item).permit(:name)
    end

    def item_tags_params
      params.require(:item).permit(:tag_name)
    end
end
