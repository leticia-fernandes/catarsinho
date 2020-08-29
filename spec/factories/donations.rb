FactoryBot.define do
  factory :donation do
    project
    donator { create(:user) }
    value { Faker::Number.positive }
  end
end
