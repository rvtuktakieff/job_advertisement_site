FactoryBot.define do
  factory :response do
    announcement { create(:announcement) }
    user { User.create }
    price { 1000 }
  end
end
