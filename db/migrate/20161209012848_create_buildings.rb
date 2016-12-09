class CreateBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :buildings do |t|
      t.integer :outlets
      t.boolean :computers
      t.boolean :study_space
      t.string :floors_integer
      t.integer :object_id

      t.timestamps
    end
  end
end
