FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 10) }
    size { Faker::Lorem.characters(number: 10) }
    user
  end
end