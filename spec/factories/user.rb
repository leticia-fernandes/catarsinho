FactoryBot.define do
  factory :user do
    name     { Faker::Movies::HarryPotter.character }
    email    { Faker::Internet.email }
    password { Faker::Number.number(digits: 6) }
  end
end
