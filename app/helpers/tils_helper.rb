# == Schema Information
#
# Table name: tils
#
#  id              :bigint(8)        not null, primary key
#  github_user_id  :bigint(8)        not null
#  pull_request_id :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_tils_on_github_user_id   (github_user_id)
#  index_tils_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#
module TilsHelper
end
