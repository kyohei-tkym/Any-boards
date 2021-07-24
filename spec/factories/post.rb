FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number:10) }
    body { Faker::Lorem.characters(number:30) }
    genre { Faker::Lorem.characters(number:10) }
  end
end