class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :release_year
      t.text :fun_facts
      t.string :production_company
      t.string :distributor

      t.timestamps
    end
  end
end
