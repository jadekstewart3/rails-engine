module Api
  module V1
    class ItemsController < ApplicationController
      def index
        if params[:merchant_id]
          begin
            merchant = Merchant.find(params[:merchant_id])
          rescue ActiveRecord::RecordNotFound => error
            render json: ErrorSerializer.new(error).serialized_error, status: 404
          else 
            render json: ItemSerializer.new(merchant.items)
          end
        else
          render json: ItemSerializer.new(Item.all)
        end
      end

      def show
        begin
          item = Item.find(params[:id])
        rescue ActiveRecord::RecordNotFound => error
          render json: ErrorSerializer.new(error).serialized_error, status: 404
        else
          render json: ItemSerializer.new(Item.find(params[:id]))
        end
      end

      def create
        begin
          render json: ItemSerializer.new(Item.create!(item_params)), status: 201
        rescue ActiveRecord::RecordInvalid => error 
          render json: ErrorSerializer.new(error).serialized_error, status: 404
        end
      end

      def update
        item = Item.find(params[:id])
        begin
         item.update!(item_params)
          render json: ItemSerializer.new(item)
        rescue  ActiveRecord::RecordInvalid => error
          render json: ErrorSerializer.new(error).serialized_error, status: 404
        end
      end

      def destroy
        item = Item.find(params[:id])
        item.get_one_item_invoices.destroy_all
        item.destroy
      end

      private
      def item_params
        params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id )
      end
    end
  end
end