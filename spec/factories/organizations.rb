FactoryBot.define do
  factory :organization do
    gh_id 1
    login "organization_name"
    name "Organization Name"
    description "This is an organization's description"
    html_url "https://github.com/platanus"
    avatar_url "https://avatars3.githubusercontent.com/u/1158740?v=4"
  end
end
