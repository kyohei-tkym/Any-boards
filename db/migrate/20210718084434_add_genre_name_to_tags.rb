class AddGenreNameToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :genre_name, :string
  end
end
