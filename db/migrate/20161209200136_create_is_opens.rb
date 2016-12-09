class CreateIsOpens < ActiveRecord::Migration[5.0]
  def change
    create_table :is_opens do |t|
      t.integer :map_object_id
      t.integer :restaurant_id
      t.string :day
      t.integer :open_time
      t.integer :close_time

      t.timestamps
    end
  end
end
