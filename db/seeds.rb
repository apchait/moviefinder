require 'csv'    

filename = 'public/Film_Locations_in_San_Francisco_cleaned.csv'

columns = {:title => 0, :release_year => 1, :location => 2, :fun_facts => 3, :production_company => 4, :distributor => 5, :director => 6, :writer => 7, :actor1 => 8, :actor2 => 9, :actor3 => 10}

Movie.delete_all
Actor.delete_all
Writer.delete_all
Director.delete_all
Location.delete_all

CSV.foreach(filename, :headers => true) do |row|

	# Use slugs instead of ids
	# Don't update if the movie already exists
	title = row[columns[:title]]
	movie = Movie.find_or_create_by title: title
	# Only update the attributes if we haven't already created the movie before
	if not movie.downcase_title
		movie.update_attributes downcase_title: title.downcase, release_year: row[columns[:release_year]], production_company: row[columns[:production_company]], distributor: row[columns[:distributor]]
	end

	# Still need to create a new location for every row
	location = Location.create description: row[columns[:location]], fun_facts: row[columns[:fun_facts]], movie_id: movie.id


	# REFACTOR - short circuit a way out by checking if the movie already has writers/directors/actors instead of pulling from the db to check, still going to need one db check
	if row[columns[:writer]]
		writers = row[columns[:writer]].split('&')
		writers.each do |w|
			name = w.rstrip.lstrip
			writer = Writer.find_or_create_by name: name
			if not movie.writers.include?(writer)
				writer.movies << movie
			end
		end
	end

	if row[columns[:director]]
		directors = row[columns[:director]].split('&')
		directors.each do |d|
			name = d.rstrip.lstrip
			director = Director.find_or_create_by name: name
			if not movie.directors.include?(director)
				director.movies << movie
			end
		end
	end

	[:actor1, :actor2, :actor3].each do |actor|
		actor = Actor.find_or_create_by name: row[columns[actor]] 
		if not movie.actors.include?(actor)
			actor.movies << movie
		end
	end
end