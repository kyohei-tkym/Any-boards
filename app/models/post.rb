class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image

  enum genre: { ショートボード:0, ミッドレングス:1, ロングボード:2, ソフトボード:3, その他:4 }

  has_many :brand_tags, dependent: :destroy
  has_many :tags, through: :brand_tags

  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
end
