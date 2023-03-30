require "rails_helper"
RSpec.describe Item, type: :model do 
  describe "Relationships" do 
    it { should belong_to :merchant }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "Validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_numericality_of :unit_price }
  end

 describe "#destroy_invoice" do
    it "destroys an invoice if only one item was on it" do
      merchant = create(:merchant)

      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)

      customer_1 = create(:customer)
      customer_2 = create(:customer)

      invoice_1 = create(:invoice, merchant: merchant, customer: customer_1)
      invoice_2 = create(:invoice, merchant: merchant, customer: customer_2)

      create(:invoice_item, item: item_1, invoice: invoice_1)
      create(:invoice_item, item: item_1, invoice: invoice_2)
      create(:invoice_item, item: item_2, invoice: invoice_2)

      expect(item_1.get_one_item_invoices).to eq([invoice_1])
    end
  end

  describe "class methods" do
    before :each do 
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      @planter = Item.create!(name: "Plant pot", description: "planter", unit_price: 13.99, merchant_id: @merchant_1.id)
      @peperomia_plant = Item.create!(name: "Nepoli Nights Peperomia Plant", description: "plant", unit_price: 11.99, merchant_id: @merchant_1.id)

      @anthirium_plant = Item.create!(name: "Anthirium Plant", description: "plant", unit_price: 12.99, merchant_id: @merchant_2.id)
      @sop_plant = Item.create!(name: "String Of Pearls Plant", description: "plant", unit_price: 8.99, merchant_id: @merchant_2.id)
      @scented_candle = Item.create!(name: "Cinnamon Scented Candle", description: "candle", unit_price: 6.99, merchant_id: @merchant_2.id)
    end

    describe ".find_all_items_by_name" do
      it "returns all of the items that match the keyword search in alphabatical order" do
        expect(Item.find_all_items_by_name("plant")).to eq([@anthirium_plant, @peperomia_plant, @planter, @sop_plant])
      end
    end

    describe "find_items_in_price_range" do
      it "returns items within a range of prices" do
        expect(Item.find_items_by_price(12.00, 15.00)).to eq([@anthirium_plant, @planter])
      end

      it "returns items with a price less than or equal to the parameter" do 
        expect(Item.find_items_by_price(nil, 8.99)).to eq([@scented_candle, @sop_plant])

        coochie_copi = Item.create!(name: "Coochie Copi Night Light", description: "night light", unit_price: 5.99, merchant_id: @merchant_2.id)

        expect(Item.find_items_by_price(nil, 8.99)).to eq([@scented_candle, coochie_copi, @sop_plant])
      end

      it "returns items with a price greater than or equal to the parameter" do 
      
        expect(Item.find_items_by_price(8.99, nil)).to eq([@anthirium_plant, @peperomia_plant, @planter, @sop_plant])
        terrerium = Item.create!(name: "Terrerium", description: "Plant terrerium", unit_price: 50.99, merchant_id: @merchant_2.id)
        
        expect(Item.find_items_by_price(8.99,nil)).to eq([@anthirium_plant, @peperomia_plant, @planter, @sop_plant, terrerium])
      end
    end
  end
end