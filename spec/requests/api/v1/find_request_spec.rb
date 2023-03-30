require "rails_helper"

RSpec.describe "Find Show" do
  describe "#find" do
    before :each do
      @ring_world = Merchant.create!(name: "Ring World")
      @ring_worm = Merchant.create!(name: "Ring Worm")
      @bling_ring = Merchant.create!(name: "Bling Ring")
    end
    
    it "can return one merchant by keyword search" do
      get "/api/v1/merchants/find?name=Ring"

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchants[:data]).to have_key(:id)
      expect(merchants[:data][:id]).to be_a(String)

      expect(merchants[:data][:attributes]).to have_key(:name)
      expect(merchants[:data][:attributes][:name]).to be_an(String)
    end

    it "will return an empty object if no merchant matches the search" do
      get "/api/v1/merchants/find?name=cat"
      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      expect(merchant).to have_key(:data)
    end
  end
end