FactoryBot.define do
  factory :pull_request_relation do
    pr_relation_type { :reviewer }
    association :pull_request
    association :github_user
    organization_id { pull_request&.repository&.organization_id || 1 }
    target_user_id { pull_request&.owner_id || 1 }
    gh_updated_at { Time.current }
  end
end
