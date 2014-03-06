class AddImdbIdToPersonality < ActiveRecord::Migration
  def change
    add_column :personalities, :imdb_id, :string
  end
end
