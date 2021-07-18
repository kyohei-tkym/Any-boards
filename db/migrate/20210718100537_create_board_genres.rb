class CreateBoardGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :board_genres do |t|
      t.references :post, foreign_key: true
      t.references :genre, foreign_key: true

      t.timestamps
    end
  end
end
