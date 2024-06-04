FactoryBot.define do
  factory :announcement do
    user { User.create }
    description { 'MyString' }
  end
end
