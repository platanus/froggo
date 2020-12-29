class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag
end

# == Schema Information
#
# Table name: taggings
#
#  id            :bigint(8)        not null, primary key
#  taggable_type :string           not null
#  taggable_id   :bigint(8)        not null
#  tag_id        :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_taggings_on_tag_id                         (tag_id)
#  index_taggings_on_taggable_type_and_taggable_id  (taggable_type,taggable_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#
