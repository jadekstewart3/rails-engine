require "rails_helper"

describe "Items API" do 
  describe "#index" do 
    it "can get all items" do 
      create_list(:item, 10)

      get "/api/v1/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(10)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

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
      
    it "can get all items for a given merchant id" do 
      merchant = create(:merchant)
      create_list(:item, 5, merchant_id: merchant.id)
  
      get "/api/v1/merchants/#{merchant.id}/items"
  
      items = JSON.parse(response.body, symbolize_names: true)
    
      expect(response).to be_successful
      expect(items[:data].count).to eq(5)
    end
      
    it "returns an error if key merchant_id does not exist" do
      get "/api/v1/merchants/27839/items"
      error_items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      expect(error_items).to have_key(:message)
      expect(error_items).to have_key(:errors)
      expect(error_items[:message]).to eq("your query could not be completed")
      expect(error_items[:errors]).to eq("The Merchant ID does not exist")
    end
  end

  describe "#show" do
    it 'can get one item by id' do
      id = create(:item).id

      get "/api/v1/items/#{id}"
      
      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:type]).to be_an(String)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_an(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_an(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_an(Float)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe "#create" do
    it "can create a new item" do
      merchant = create(:merchant)
      item_params =({id: 82,
                    name: "Jospeh",
                    description: "The programs that Chuck Norris writes don't have version numbers because he only writes them once. If a user reports a bug or has a feature request they don't live to see the sun set.",
                    unit_price: 42.91,
                    merchant_id: merchant.id
                  })
      headers = {"CONTENT_TYPE" => "application/json"}
      
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last
    
      expect(response).to be_successful
      expect(created_item.id).to eq(item_params[:id])
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe "#update" do
    it "can edit an existing item" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Thingy"}
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Thingy")
    end

    it "returns an error if the item is not updated" do
      id = create(:item).id

      item_params = { name: "Thingy", merchant_id: 131232}
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

      errors = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(errors).to have_key(:message)
      expect(errors).to have_key(:errors)
      expect(errors[:message]).to eq("your query could not be completed")
      expect(errors[:errors]).to eq("The Merchant ID does not exist")
    end
  end

  describe "#destroy" do 
    it "can delete an existing item" do
      item = create(:item)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      ##edit this test for error messages
    end

    it "deletes an invoice if the item being deleted is the only item on it" do
      merchant = create(:merchant)
      item = create(:item)
      customer = create(:customer)
      invoice = create(:invoice, merchant: merchant, customer: customer)
      create(:invoice_item, item: item, invoice: invoice)

      expect(Item.count).to eq(1)
      expect(Invoice.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect(Invoice.count).to eq(0)
    end
  end

  describe "#find_all" do 
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      @coochie_copi = Item.create!(name: "Bobs Burgers- Coochie Copi", description: "Coochie Copi Night Light", unit_price: 10.99, merchant_id: @merchant_1.id)
      @melodica = Item.create!(name: "Bobs Burgers- Melodica", description: "Melodica", unit_price: 15.99, merchant_id: @merchant_1.id)
      @napkin_holder = Item.create!(name: "Bobs Burgers- Napkin Holder", description: "Melodica", unit_price: 20.99, merchant_id: @merchant_1.id)

      @glasses = Item.create!(name: "Bobs Burgers- Tinas Glasses", description: "Melodica", unit_price: 50.99, merchant_id: @merchant_2.id)
      @plant = Item.create!(name: "Alocasia", description: "Alocasia Black Velvet", unit_price: 16.99, merchant_id: @merchant_2.id)
    end

    it "can find all items by keyword" do
      get "/api/v1/items/find_all?name=bob"

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
     
      items[:data].each do |item|
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