class OrganizationSync < ApplicationRecord
  include AASM
  belongs_to :organization

  aasm column: 'state' do
    state :created, initial: true
    state :executing
    state :completed
    state :failed

    event :execute, after: Proc.new { update(start_time: DateTime.current) } do
      transitions from: :created, to: :executing
      transitions from: :completed, to: :executing
    end

    event :fail, after: Proc.new { update(end_time: DateTime.current) } do
      transitions from: :executing, to: :failed
    end

    event :complete, after: Proc.new { update(end_time: DateTime.current) } do
      transitions from: :executing, to: :completed
    end
  end
end

# == Schema Information
#
# Table name: organization_syncs
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  state           :string
#  start_time      :datetime
#  end_time        :datetime
#
# Indexes
#
#  index_organization_syncs_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
