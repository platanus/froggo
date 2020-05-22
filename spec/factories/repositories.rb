FactoryBot.define do
  factory :repository do
    association :organization

    gh_id { 1 }
    name { "MyString" }
    full_name { "MyString" }
    tracked { false }
    url { "MyString" }
    html_url { "MyString" }

    factory :repository_with_pull_requests_and_reviews do
      transient do
        pull_request_count { 5 }
        reviews_count { 3 }
      end

      after(:create) do |profile, evaluator|
        create_list(:pull_request_with_reviews,
                    evaluator.pull_request_count,
                    reviews_count: evaluator.reviews_count,
                    repository: profile)
      end
    end
  end
end
