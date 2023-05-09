FactoryBot.define do
  factory :package do
    association :team
    name { "MyString" }
  end
end
