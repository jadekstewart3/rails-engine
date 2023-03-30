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

    it "returns an empty array if no merchants exist" do 
      get "/api/v1/merchants"
      expect(response).to be_successful
      
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to eq([])
    end
  end

  describe "Merchant Show" do
    it "can get one merchant by id" do 
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response).to have_http_status(200)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_an(String)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_an(String)
    end

    it "can return the merchant associated with an item" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      expect(merchant_response).to have_key(:data)
      expect(merchant_response[:data]).to be_a(Hash)

      expect(merchant_response[:data]).to have_key(:id)
      expect(merchant_response[:data][:id]).to be_a(String)

      expect(merchant_response[:data]).to have_key(:attributes)
      expect(merchant_response[:data][:attributes]).to be_a(Hash)

      expect(merchant_response[:data][:attributes]).to have_key(:name)
      expect(merchant_response[:data][:attributes][:name]).to be_a(String)
    end

    it "will return an error if the merchant does not exist" do 
      get "/api/v1/merchants/1272327185"
      
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      expect(merchant).to have_key(:message)
      expect(merchant).to have_key(:errors)
      expect(merchant[:message]).to eq("your query could not be completed")
      expect(merchant[:errors]).to eq("Couldn't find Merchant with 'id'=1272327185")
    end
  end
end