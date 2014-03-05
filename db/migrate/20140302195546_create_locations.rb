class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :description
      t.string :formatted_address
      t.decimal :lat
      t.decimal :lng
      t.decimal :ne_lat
      t.decimal :ne_lng
      t.decimal :sw_lat
      t.decimal :sw_lng
      t.integer :movie_id

      t.timestamps
    end
  end
end
