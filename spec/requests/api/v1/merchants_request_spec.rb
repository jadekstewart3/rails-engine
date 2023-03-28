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
      get "/api/v1/merchants/1"

      expect(response).to_not be_successful
      expect(response).to have_status(404)

    end
  end
end