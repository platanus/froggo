FactoryBot.define do
  factory :repositories_sync do
    association :organization
    synced_at "2018-04-11"
  end
end
