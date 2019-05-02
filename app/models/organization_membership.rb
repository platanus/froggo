class OrganizationMembership < ApplicationRecord
  belongs_to :github_user
  belongs_to :organization
end

# == Schema Information
#
# Table name: organization_memberships
#
#  id                      :integer          not null, primary key
#  github_user_id          :integer
#  organization_id         :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  default_team_membership :boolean          default(FALSE)
#
# Indexes
#
#  index_organization_memberships_on_github_user_id   (github_user_id)
#  index_organization_memberships_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#  fk_rails_...  (organization_id => organizations.id)
#
