module Api
  module V1
    class FindAllController < ApplicationController

      def index
        if params[:name] && (params[:min_price] || params[:max_price])
          render json: { errors: "Cannot search name and price" }, status: 400
        elsif params[:name]
          search_by_name
        else
          search_by_price
        end
      end

      private
      def search_by_name
        items = Item.find_all_items_by_name(params[:name])
        if items.nil?
          render json: {errors: "No results found"}, status: 404
        else
          render json: ItemSerializer.new(items)
        end
      end

      def search_by_price
        if (params[:min_price].to_f < 0) || (params[:max_price].to_f < 0)
          render json: {errors: "Price cannot be less than zero" }, status: 400
        else
          items = Item.find_items_by_price(params[:min_price], params[:max_price])
          if items.nil?
            render json: {errors: "No matches found"}, status: 400
          else
            render json: ItemSerializer.new(items)
          end
        end
      end
    end
  end
end