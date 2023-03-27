module Api
  module V1
    class ItemsController < ApplicationController
      def index
        if params[:merchant_id]
          merchant = Merchant.find(params[:merchant_id])
          render json: merchant.items
        else
          render json: Item.all
        end
      end

      def show
        render json: Item.find(params[:id])
      end

      def create
        render json: Item.create!(item_params)
      end

      def update
        render json: Item.update(params[:id], item_params)
      end

      def destroy
        render json: Item.delete(params[:id])
      end

      private
      def item_params
        params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id )
      end
    end
  end
end