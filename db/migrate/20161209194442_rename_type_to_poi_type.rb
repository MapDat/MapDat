class RenameTypeToPoiType < ActiveRecord::Migration[5.0]
  def change
    rename_column :pois, :type, :poi_type
  end
end
