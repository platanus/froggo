FactoryBot.define do
  factory :organization_membership do
    association :organization
    association :github_user
  end
end
