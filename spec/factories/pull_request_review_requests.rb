FactoryBot.define do
  factory :pull_request_review_request do
    association :pull_request
    association :github_user
    gh_id 1
  end
end
