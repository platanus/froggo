FactoryBot.define do
  factory :organization do
    sequence(:gh_id)
    login "organization_name"
    name "Organization Name"
    description "This is an organization's description"
    html_url "https://github.com/platanus"
    avatar_url "https://avatars3.githubusercontent.com/u/1158740?v=4"
    tracked false
  end
end
