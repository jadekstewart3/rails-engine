class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items

  validates :name, presence: true

  def self.find_one_merchant(keyword)
    where("name ILIKE ?", "%#{keyword}%")
    .first
  end
end