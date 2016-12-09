class FixIdName < ActiveRecord::Migration[5.0]
  def change
    rename_column :buildings, :object_id, :map_object_id
    rename_column :geo_points, :object_id, :map_object_id

  end
end
