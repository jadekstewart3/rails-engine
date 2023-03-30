require "rails_helper"

describe "Find All Index" do
  describe "#find_all" do 
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      @coochie_copi = Item.create!(name: "Bobs Burgers- Coochie Copi", description: "Coochie Copi Night Light", unit_price: 10.99, merchant_id: @merchant_1.id)
      @melodica = Item.create!(name: "Bobs Burgers- Melodica", description: "Melodica", unit_price: 15.99, merchant_id: @merchant_1.id)
      @napkin_holder = Item.create!(name: "Bobs Burgers- Napkin Holder", description: "Melodica", unit_price: 20.99, merchant_id: @merchant_1.id)

      @glasses = Item.create!(name: "Bobs Burgers- Tinas Glasses", description: "Tina's Old Glasses", unit_price: 50.99, merchant_id: @merchant_2.id)
      @plant = Item.create!(name: "Alocasia", description: "Alocasia Black Velvet", unit_price: 16.99, merchant_id: @merchant_2.id)
    end
    
    it "can find all items by keyword" do
      get "/api/v1/items/find_all?name=bob"
      
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      
      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
      
    it "can find all items by min value" do
      get "/api/v1/items/find_all?min_price=16.99"
      
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      
      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
      
    it "can find all items by max value" do
      get "/api/v1/items/find_all?max_price=16.99"
      
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      
      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
    
    it "can find all items within a range of prices" do
      get "/api/v1/items/find_all?max_price=51.00&min_price=16.00"
      
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      
      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end
end