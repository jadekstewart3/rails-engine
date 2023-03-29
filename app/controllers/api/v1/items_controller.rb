module Api
  module V1
    class ItemsController < ApplicationController
      def index
        if params[:merchant_id]
          begin
            merchant = Merchant.find(params[:merchant_id])
          rescue ActiveRecord::RecordNotFound
            render json: {
              "message": "your query could not be completed",
              "errors": "The Merchant ID does not exist"
            }, status: 404
          else 
            render json: ItemSerializer.new(merchant.items)
          end
        else
          render json: ItemSerializer.new(Item.all)
        end
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        render json: ItemSerializer.new(Item.create!(item_params)), status: 201
      end

      def update
        item = Item.find(params[:id])
        if item.update(item_params)
          render json: ItemSerializer.new(item)
        else
          render json: {
            "message": "your query could not be completed",
            "errors": "The Merchant ID does not exist"
          }, status: 404
        end
      end

      def destroy
        item = Item.find(params[:id])
        item.get_one_item_invoices.destroy_all
        item.destroy
      end

      def find_all
        items = Item.find_all_items_by_name(params[:name])
        render json: ItemSerializer.new(items)
      end

      private
      def item_params
        params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id )
      end
    end
  end
end