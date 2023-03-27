module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: Merchant.all
      end

      def show
        render json: Merchant.find(params[:id])
      end
    end
  end
end