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
      it "returns all of the items that match the keyword search" do
        expect(Item.find_all_items_by_name("plant")).to eq([@planter, @peperomia_plant, @anthirium_plant, @sop_plant])
      end
    end

    describe ".find_items_by_min_price" do 
      it "returns items with a price greater than or equal to the parameter" do 
        
        expect(Item.find_items_by_min_price(8.99).to_a).to eq([@planter, @anthirium_plant, @peperomia_plant, @sop_plant])
        terrerium = Item.create!(name: "Terrerium", description: "Plant terrerium", unit_price: 50.99, merchant_id: @merchant_2.id)
        
        expect(Item.find_items_by_min_price(8.99)).to eq([terrerium, @planter, @anthirium_plant, @peperomia_plant, @sop_plant])
      end
    end

    describe ".find_items_by_max_price" do 
      it "returns items with a price less than or equal to the parameter" do 
        expect(Item.find_items_by_max_price(8.99)).to eq([@sop_plant, @scented_candle])

        choochie_copi = Item.create!(name: "Coochie Copi Night Light", description: "night light", unit_price: 6.99, merchant_id: @merchant_2.id)

        expect(Item.find_items_by_max_price(8.99)).to eq([@sop_plant, @scented_candle, choochie_copi])
      end
    end
  end
end