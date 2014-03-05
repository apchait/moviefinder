class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :description
      t.string :formatted_address
      t.decimal :lat
      t.decimal :long
      t.decimal :ne_lat
      t.decimal :ne_long
      t.decimal :sw_lat
      t.decimal :sw_long
      t.integer :movie_id

      t.timestamps
    end
  end
end
