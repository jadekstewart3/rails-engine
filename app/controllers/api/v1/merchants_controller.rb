module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        if params[:item_id]
          merchant = Item.find(params[:item_id]).merchant
          begin
            merchant = Merchant.find(params[:id])
          rescue ActiveRecord::RecordNotFound
             render json: {
              "message": "your query could not be completed",
              "errors": "The Merchant ID does not exist"
            }, status: 404
          else
            render json: MerchantSerializer.new(merchant)
          end
        else
          render json: MerchantSerializer.new(merchant)
        end
      end
    end
  end
end