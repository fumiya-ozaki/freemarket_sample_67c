class PurchaseController < ApplicationController

  require 'payjp'

  def index
    if user_signed_in?
      card = Card.where(user_id: current_user.id).first
      @item = Item.find(params[:item_id])
      @image_first = @item.images[0]
      @image_others = @item.images[1..3]
      @address = Address.find_by(user_id: current_user)


      if @item.status == "closed"
        redirect_to item_path(@item),alert:"購入済商品です"
      end

      #Cardテーブルは前回記事で作成、テーブルからpayjpの顧客IDを検索
      if card.blank?
        #登録された情報がない場合にカード登録画面に移動
        redirect_to controller: "card", action: "new"
      else
        Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
        #保管した顧客IDでpayjpから情報取得
        customer = Payjp::Customer.retrieve(card.customer_id)
        #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
        @default_card_information = customer.cards.retrieve(card.card_id)
      end
    else
      redirect_to new_user_registration_path,alert:"ユーザー登録が完了していません"
    end
  end

  def pay
    @item = Item.find(params[:item_id])
      
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    if user_signed_in?
      if @item.status = "closed"
        redirect_to item_path(@item)
      elsif current_user.id == @item.seller_id
        redirect_to item_path(@item)
      else
        Payjp::Charge.create(
        :amount => @item.price, #支払金額を入力（itemテーブル等に紐づけても良い）
        :customer => card.customer_id, #顧客ID
        :currency => 'jpy', #日本円
      )
        redirect_to action: 'done' #完了画面に移動
      end
    else
      redirect_to root_path
    end
  end

  def done
    @item = Item.find(params[:item_id])
    if user_signed_in?
      if @item.status = "closed"
        redirect_to item_path(@item)
      elsif current_user.id == @item.seller_id
        redirect_to item_path(@item)
      else
        @item_purchaser= Item.find(params[:item_id])
        @item_purchaser.update( buyer_id: current_user.id)
        @item.update( status: "closed")
      end
    else
      redirect_to root_path
    end
  end
end