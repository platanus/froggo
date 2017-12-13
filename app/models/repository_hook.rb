class RepositoryHook < ApplicationRecord
  belongs_to :repositories
  belongs_to :hooks
end

# == Schema Information
#
# Table name: repository_hooks
#
#  id            :integer          not null, primary key
#  hook_id       :integer
#  repository_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
