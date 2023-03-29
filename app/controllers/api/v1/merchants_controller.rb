module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        begin
          if params[:item_id]
            merchant = Item.find(id]).merchant
          else
            merchant = Merchant.find(params[:id])
          end
          render json: MerchantSerializer.new(merchant)
        rescue ActiveRecord::RecordNotFound
          render json: {
              "message": "your query could not be completed",
              "errors": "The Merchant ID does not exist"
            }, status: 404
        end
      end

      def find 
        merchant = Merchant.find_one_merchant(params[:name])
        if merchant.nil?
          render json: {
            "message": "your query could not be completed",
            "errors": "No Merchant matches your search"
            }, status: 404
        else
          render json: MerchantSerializer.new(merchant)
        end
      end
    end
  end
end