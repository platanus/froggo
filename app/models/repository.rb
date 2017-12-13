class Repository < ApplicationRecord
  include ActiveModel::Dirty
  has_many :pull_requests
  has_many :hooks

  after_save :update_hook

  def update_hook
    @hook_service = HookService.new
    if tracked_changed? && tracked
      @hook_service.subscribe(self)
    elsif tracked_changed? && !tracked
      @hook_service.unsubscribe(self)
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
