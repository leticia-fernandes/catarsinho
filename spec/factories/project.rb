FactoryBot.define do
  factory :project do
    title        { Faker::Movies::HarryPotter.book[0..63] }
    description  { Faker::Lorem.paragraph_by_chars(number: 512) }
    goal         { Faker::Number.within(range: 1..500) }
    closing_date { Faker::Date.between(from: Date.tomorrow, to: Date.today+29.days ) }
    image        { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-img.png'), 'image/png') }
    user

    trait :with_donations do
      after(:create) do |project|
        project.donations << build(:donation)
        project.donations << build(:donation)
      end
    end
  end
end
