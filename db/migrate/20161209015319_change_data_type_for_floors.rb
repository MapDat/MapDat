class ChangeDataTypeForFloors < ActiveRecord::Migration[5.0]
  def change
    rename_column :buildings, :floors_integer, :floors
  end
end
