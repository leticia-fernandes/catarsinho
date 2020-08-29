FactoryBot.define do
  factory :project do
    title        { Faker::Name.name[1..64] }
    description  { Faker::Lorem.paragraph_by_chars(number: 512) }
    goal         { Faker::Number.within(range: 1..500) }
    closing_date { Faker::Date.between(from: Date.tomorrow, to: Date.today+29.days ) }
    user
  end
end
