class PullRequest < ApplicationRecord
  belongs_to :repository
end

# == Schema Information
#
# Table name: pull_requests
#
#  id            :integer          not null, primary key
#  gh_id         :integer
#  title         :string
#  gh_number     :integer
#  pr_state      :string
#  html_url      :string
#  gh_created_at :datetime
#  gh_updated_at :datetime
#  gh_closed_at  :datetime
#  gh_merged_at  :datetime
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_pull_requests_on_user_id  (user_id)
#
