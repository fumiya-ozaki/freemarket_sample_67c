class RenameImageColumnToImages < ActiveRecord::Migration[5.2]
  def change
      rename_column :images, :image, :image_01   
  end
end
