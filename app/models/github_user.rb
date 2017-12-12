class GithubUser < ApplicationRecord
  validates :gh_id, presence: true
  validates :login, presence: true
  validates :name, presence: true
end

# == Schema Information
#
# Table name: github_users
#
#  id         :integer          not null, primary key
#  avatar_url :string
#  email      :string
#  gh_id      :integer
#  html_url   :string
#  login      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
