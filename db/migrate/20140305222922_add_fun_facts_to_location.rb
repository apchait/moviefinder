class AddFunFactsToLocation < ActiveRecord::Migration
  def change
  	remove_column :movies, :fun_facts
    add_column :locations, :fun_facts, :text
  end
end
