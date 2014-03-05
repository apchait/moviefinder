class Personality < ActiveRecord::Base
	# Would have liked to abstract the movie-actor/writer/director relationship here, but ruby will not check if the instances returned here are instances of subclasses to be able to seperate them out for display
	has_and_belongs_to_many :movies
end
