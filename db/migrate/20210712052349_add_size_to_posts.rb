class AddSizeToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :size, :string
  end
end
