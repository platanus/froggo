FactoryBot.define do
  factory :repository do
    association :organization

    gh_id 1
    name "MyString"
    full_name "MyString"
    tracked false
    url "MyString"
    html_url "MyString"
  end
end
