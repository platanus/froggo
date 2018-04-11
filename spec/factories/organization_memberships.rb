FactoryBot.define do
  factory :organization_membership do
    association :organization
    association :github_user
    tracked true
  end
end
