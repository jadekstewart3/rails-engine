class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_numericality_of :unit_price, greater_than: 0
  validates :name, :description, presence: true

  def get_one_item_invoices
    invoices
    .joins(:invoice_items)
    .group(:id)
    .having("COUNT(invoice_items.id) = 1")
  end

  def self.find_all_items_by_name(keyword)
    where("name ILIKE ?", "%#{keyword}%").order(name: :asc)
  end

  # def self.find_items_by_min_price(min_value)
  #   where("unit_price >= ?", "#{min_value}").order(unit_price: :desc)
  # end

  # def self.find_items_by_max_price(max_value)
  #   where("unit_price <= ?", "#{max_value}").order(unit_price: :desc)
  # end

  def self.find_items_by_price(min, max)
    if min != nil && max != nil
      where("unit_price >= ? AND unit_price <= ?", min, max)
    elsif min == nil
      where("unit_price <= ?", max)
    else  
      where("unit_price >= ?", min)
    end.order(name: :asc)
  end
end