class AddImageToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :image, :text
  end
end
