class Repository < ApplicationRecord
  include ActiveModel::Dirty
  has_many :pull_requests
  has_many :repository_hooks

  after_save :create_hook

  def create_hook
    if tracked_changed? && tracked == true
      @hook_service = HookService.new
      @hook_service.subscribe(self)
    end
  end
end

# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  gh_id      :integer
#  name       :string
#  full_name  :string
#  tracked    :boolean
#  url        :string
#  html_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
