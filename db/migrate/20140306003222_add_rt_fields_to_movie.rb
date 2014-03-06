class AddRtFieldsToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :rt_id, :integer
    add_column :movies, :mpaa_rating, :string
    add_column :movies, :critics_score, :integer
    add_column :movies, :audience_score, :integer
    add_column :movies, :synopsis, :text
    add_column :movies, :poster_url, :string
    add_column :movies, :clip_url, :string
    add_column :movies, :clip_thumb_url, :string
    
  end
end
