class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :github_users, through: :taggings, source: :taggable, source_type: 'GithubUser'
end

# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
