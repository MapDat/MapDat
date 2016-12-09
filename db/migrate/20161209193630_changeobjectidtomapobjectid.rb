class Changeobjectidtomapobjectid < ActiveRecord::Migration[5.0]
  def change
    rename_column :pois, :object_id, :map_object_id
  end
end
