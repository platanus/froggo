FactoryBot.define do
  factory :github_user do
    sequence(:gh_id)
    avatar_url { "https://avatars2.githubusercontent.com/u/741483?v=4" }
    email { "jpbunzli@gmail.com" }
    html_url { "https://github.com/bunzli" }
    login { "bunzli" }
    name { "Jaime Bunzli" }
  end
end
