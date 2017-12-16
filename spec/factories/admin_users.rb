FactoryBot.define do
  factory :admin_user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "password123"
    password_confirmation "password123"
  end
end
