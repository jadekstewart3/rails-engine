require "rails_helper"
RSpec.describe Merchant, type: :model do
  describe "Relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe "Validations" do
    it { should validate_presence_of :name }
  end

  describe ".scope" do 
    describe ".find_one_merchant" do
      it "returns the first merchant in the database based on the search criteria" do
        ring_world = Merchant.create!(name: "Ring World")
        ring_worm = Merchant.create!(name: "Ring Worm")
        bling_ring = Merchant.create!(name: "Bling Ring")
        
        expect(Merchant.find_one_merchant("Ring")).to eq(ring_world)
      end
    end
  end
end