FactoryBot.define do
  factory :pull_request do
    association :repository
    gh_id 1
    title 'Prueba'
    gh_number 1
    pr_state 'open'
    html_url 'http://www.gihub.com/prueba'
    gh_created_at '2017-12-12 09:17:52'
    gh_updated_at '2017-12-12 09:17:52'
    gh_closed_at '2017-12-12 09:17:52'
    gh_merged_at '2017-12-12 09:17:52'

    association :owner, factory: :github_user

    factory :pull_request_with_reviews do
      transient do
        reviews_count 5
      end

      after(:create) do |profile, evaluator|
        create_list(:pull_request_review, evaluator.reviews_count, pull_request: profile)
      end
    end
  end
end
