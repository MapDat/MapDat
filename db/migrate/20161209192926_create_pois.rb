class CreatePois < ActiveRecord::Migration[5.0]
  def change
    create_table :pois do |t|
      t.string :type
      t.integer :object_id

      t.timestamps
    end
  end
end
