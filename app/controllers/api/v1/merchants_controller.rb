module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        begin
          if params[:item_id]
            merchant = Item.find(params[:item_id]).merchant
          else
            merchant = Merchant.find(params[:id])
          end
          render json: MerchantSerializer.new(merchant)
        rescue ActiveRecord::RecordNotFound => error
          render json: ErrorSerializer.new(error).serialized_error, status: 404
        end
      end
    end
  end
end