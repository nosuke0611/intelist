class ItemsController < ApplicationController
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
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
  end


  private
    def item_params
      params.require(:item).permit(:name)
    end
end
