class RepositoriesSync < ApplicationRecord
  belongs_to :organization
end

# == Schema Information
#
# Table name: repositories_syncs
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  synced_at       :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_repositories_syncs_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
