FactoryBot.define do
  factory :package_version do
    association :package
    name { "MyString" }
    description { "MyString" }
  end
end
