class CreateMoviesPersonalities < ActiveRecord::Migration
  def change
    create_table :movies_personalities do |t|
      t.integer :movie_id
      t.integer :personality_id
      t.integer :actor_id
      t.integer :director_id
      t.integer :writer_id
    end
  end
end
