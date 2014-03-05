class CreatePersonalities < ActiveRecord::Migration
  def change
    create_table :personalities do |t|
      t.string :name
      t.string :type
      
      t.timestamps
    end
  end
end
