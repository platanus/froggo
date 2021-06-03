class Preference < ApplicationRecord
  belongs_to :user
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
#  user_id                 :bigint(8)        not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
