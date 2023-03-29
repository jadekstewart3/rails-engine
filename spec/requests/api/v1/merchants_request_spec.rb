require "rails_helper"

describe "Merchants API" do
  describe "Merchants Index" do
    it "can get all merchants" do
      create_list(:merchant, 5)

      get "/api/v1/merchants"
      expect(response).to be_successful
      
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchants[:data].count).to eq(5)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end
  end

  describe "Merchant Show" do
    it "can get one merchant by id" do 
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_an(String)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_an(String)
    end

    it "will return an error if the merchant does not exist" do 
      get "/api/v1/merchants/1272327185"
      
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      expect(merchant).to have_key(:message)
      expect(merchant).to have_key(:errors)
      expect(merchant[:message]).to eq("your query could not be completed")
      expect(merchant[:errors]).to eq("The Merchant ID does not exist")
    end
  end

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
      expect(merchants[:data][:attributes][:name]).to be_a(String)
    end

    it "will return an error if no merchant matches the search" do
      get "/api/v1/merchants/find?name=cat"
      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      expect(merchant).to have_key(:message)
      expect(merchant).to have_key(:errors)
      expect(merchant[:message]).to eq("your query could not be completed")
      expect(merchant[:errors]).to eq("No Merchant matches your search")
    end
  end
end