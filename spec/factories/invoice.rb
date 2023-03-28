FactoryBot.define do
  factory :invoice do
    status { "shipped" }
   merchant { create(:merchant) }
   merchant { create(:customer) }
  end
end