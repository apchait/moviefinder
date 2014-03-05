require 'csv'    

filename = 'public/Film_Locations_in_San_Francisco.csv'

columns = {:title => 0, :release_year => 1, :locations => 2, :fun_facts => 3, :production_company => 4, :distributor => 5, :director => 6, :writer => 7, :actor1 => 8, :actor2 => 9, :actor3 => 10}

pure = []
paren = []
pier = []
none = []
# CSV.foreach(filename, :headers => true) do |row|
# 	location = row[columns['locations']]
# 	if location
# 		# If the string starts with the address
# 		pure_match = location.match(/(^\d+.*)/) 
# 		# Some strings have a name then an address in parens
# 		paren_match = location.match(/\((\d+.*?)\)/)
# 		pier_match = false		
# 		if pure_match
# 			pure << pure_match
# 		elsif pier_match
# 			pier << location
# 		elsif paren_match
# 			paren << [location, paren_match[1]]
# 		else
# 			none << location
# 		end
# 	end
# end

# puts 'pure'
# puts pure
# puts 'paren'
# puts paren
# puts 'none'
# puts none

Movie.delete_all
Actor.delete_all
Writer.delete_all
Director.delete_all

CSV.foreach(filename, :headers => true) do |row|
	puts columns[:writer]
	puts row[columns[:writer]]
	puts row[7]


	movie = Movie.find_or_create_by title: row[columns[:title]]
	movie.update_attributes release_year: row[columns[:release_year]], fun_facts: row[columns[:fun_facts]], production_company: row[columns[:production_company]], distributor: row[columns[:distributor]]

	if row[columns[:writer]]
		writer = Writer.find_or_create_by name: row[columns[:writer]]
		if not movie.writers.include?(writer)
			writer.movies << movie
		end
	end

	# Split on multiple if comma is presnet
	if row[columns[:director]] and not movie.directors
		director = Director.find_or_create_by name: row[columns[:director]]
		if not movie.directors.include?(directors)
			director.movies << movie
		end
	end

	[:actor1, :actor2, :actor3].each do |actor|
		actor = Actor.find_or_create_by name: row[columns[actor]] 
		if not movie.actors.include?(actor)
			actor.movies << movie
		end
	end
end