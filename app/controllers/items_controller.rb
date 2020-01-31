class ItemsController < ApplicationController
  
  def index

  end

  def new
    @item = Item.new
  end

  def create
    Item.create(item_params)
  end

  def show
    # @item = Item.find(params[:id])
  end

  private
  def item_params
    params.require(:item).permit(:id, :image)
  end

end
