class Genre < ApplicationRecord
  has_many :board_genres, dependent: :destroy
  has_many :posts, through: :board_genres
end
