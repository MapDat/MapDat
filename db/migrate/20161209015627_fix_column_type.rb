class FixColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :buildings, :floors, 'integer USING CAST(floors AS integer)'
  end
end
