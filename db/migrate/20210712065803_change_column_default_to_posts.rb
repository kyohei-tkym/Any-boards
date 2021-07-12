class ChangeColumnDefaultToPosts < ActiveRecord::Migration[5.2]
  def change
    change_column_default :posts, :genre, from: nil, to: "0"
  end
end
