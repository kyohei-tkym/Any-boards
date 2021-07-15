class Tag < ApplicationRecord
  has_many :brand_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :brand_tags
end
