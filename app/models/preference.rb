class Preference < ApplicationRecord
  belongs_to :github_user
  enum default_time: {
    one_month: 0,
    three_months: 1,
    six_months: 2,
    nine_months: 3,
    twelve_months: 4
  }
  validates :default_organization_id, :default_team_id, :default_time, presence: true
end

# == Schema Information
#
# Table name: preferences
#
#  id                      :bigint(8)        not null, primary key
#  default_organization_id :bigint(8)
#  default_team_id         :bigint(8)
#  default_time            :bigint(8)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  github_user_id          :bigint(8)
#
# Indexes
#
#  index_preferences_on_github_user_id  (github_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#
