FactoryBot.define do
  factory :pull_request_relation do
    association :pull_request
    association :github_user
    relation_type 'asignee'
  end
end
