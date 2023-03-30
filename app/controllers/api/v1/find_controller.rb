module Api
  module V1
    class FindController < ApplicationController
      def show 
        merchant = Merchant.find_one_merchant(params[:name])
        if merchant.nil?
          render json: {
            "data": {}
            }, status: 200
        else
          render json: MerchantSerializer.new(merchant)
        end
      end
    end
  end
end