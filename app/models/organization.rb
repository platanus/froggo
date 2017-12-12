class Organization < ApplicationRecord
  validates :ghid, presence: true
  validates :login, presence: true
end

# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  ghid        :integer
#  login       :string
#  description :string
#  html_url    :string
#  avatar_url  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
