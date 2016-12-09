class CreateMapObjects < ActiveRecord::Migration[5.0]
  def change
    create_table :map_objects do |t|
      t.string :name
      t.string :abbrev
      t.text :description
      t.string :image_path

      t.timestamps
    end
  end
end
