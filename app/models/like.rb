class Like < ApplicationRecord
  belongs_to :github_user
  belongs_to :likeable, polymorphic: true
  validates :likeable_id, uniqueness: { scope: %i[likeable_type github_user] }
end

# == Schema Information
#
# Table name: likes
#
#  id             :bigint(8)        not null, primary key
#  github_user_id :bigint(8)        not null
#  likeable_type  :string           not null
#  likeable_id    :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_likes_on_github_user_id                 (github_user_id)
#  index_likes_on_likeable_type_and_likeable_id  (likeable_type,likeable_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#
