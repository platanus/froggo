class Hook < ApplicationRecord
  include PowerTypes::Observable

  belongs_to :resource, polymorphic: true
  validates :gh_id, presence: true
  validates :resource_id, presence: true
  validates :resource_type, presence: true
end

# == Schema Information
#
# Table name: hooks
#
#  id            :bigint(8)        not null, primary key
#  hook_type     :string
#  gh_id         :integer
#  name          :string
#  active        :boolean
#  ping_url      :string
#  test_url      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_type :string
#  resource_id   :bigint(8)
#
# Indexes
#
#  index_hooks_on_resource_type_and_resource_id  (resource_type,resource_id)
#
