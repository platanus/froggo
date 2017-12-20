FactoryBot.define do
  factory :hook do
    hook_type "Repository"
    gh_id 1
    name "web"
    active false
    ping_url "MyString"
    test_url "MyString"
  end
end
