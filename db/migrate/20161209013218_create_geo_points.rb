class CreateGeoPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_points do |t|
      t.decimal :longitude
      t.decimal :latitude
      t.integer :object_id

      t.timestamps
    end
  end
end
