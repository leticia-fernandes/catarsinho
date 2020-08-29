FactoryBot.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password { Faker::Number.number(digits: 6) }
  end
end
