namespace :script do
	desc "Geocode Movie Locations"
	task geocode_locations: :environment do
		require 'httparty'
		# Make key an ENV var
		KEY = "AIzaSyBnp5wx1dBlTVW-CmTYsX6-O92GyGnhs9o"

		Location.where("lat is NULL").each do |location|
			if location.description
				puts "Geocoding #{location.description}"
				url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location.description.gsub(' ', '+')}+San+Francisco+CA&sensor=true&key=#{KEY}"
				r = HTTParty.get(url)
				if r["results"][0]
					attributes = {
						:formatted_address => r["results"][0]["formatted_address"],
						:lat => r["results"][0]["geometry"]["location"]["lat"],
						:lng => r["results"][0]["geometry"]["location"]["lng"],
						:ne_lat => r["results"][0]["geometry"]["viewport"]["northeast"]["lat"],
						:ne_lng => r["results"][0]["geometry"]["viewport"]["northeast"]["lng"],
						:sw_lat => r["results"][0]["geometry"]["viewport"]["southwest"]["lat"],
						:sw_lng => r["results"][0]["geometry"]["viewport"]["southwest"]["lng"]
					}
					puts location.update_attributes attributes
				else
					# Check for errors in repsonse
					puts "No Luck"
				end
			end
		end
	end

	desc "Find Locations That Are Out Of Bounds From San Francisco Area And Fix"
	task oob_locations: :environment do
		KEY = "AIzaSyBnp5wx1dBlTVW-CmTYsX6-O92GyGnhs9o"
		Location.all.each do |location|
			if location.lat > 38.552461 or location.lat < 36.774092 or location.lng < -123.301363 or location.lng > -120.104097
				puts location.description
				url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location.description.gsub(' ', '+')}+San+Francisco+CA+USA&sensor=true&key=#{KEY}"
				puts url
				if false # if param to geocode
					# Check if there is an & since Google Maps API prefers "and"
					if location.description.match /&/
						location.update_attributes description: location.description.gsub("&", "and")
					end
					# Check if there is an adress in parens at the end of the location string
					# String is something like "500 Club (500 Guerrero)""
					m = location.description.match(/(.*?)\s*\((\d+.*?)\)$/)
					if m
						# swap the address out of parens
						location.update_attributes description: "#{m[2]} (#{m[1]})"
					end
					puts "Geocoding #{location.description}"
					r = HTTParty.get(url)
					if r["results"][0]
						attributes = {
							:formatted_address => r["results"][0]["formatted_address"],
							:lat => r["results"][0]["geometry"]["location"]["lat"],
							:lng => r["results"][0]["geometry"]["location"]["lng"],
							:ne_lat => r["results"][0]["geometry"]["viewport"]["northeast"]["lat"],
							:ne_lng => r["results"][0]["geometry"]["viewport"]["northeast"]["lng"],
							:sw_lat => r["results"][0]["geometry"]["viewport"]["southwest"]["lat"],
							:sw_lng => r["results"][0]["geometry"]["viewport"]["southwest"]["lng"]
						}
						puts location.update_attributes attributes
					else
						# Check for errors in repsonse
						puts "No Luck"
					end
				end
			end
		end
	end

	desc "Import Fun Facts Into Locations From CSV"
	task import_facts: :environment do
		require 'csv'
		filename = 'public/Film_Locations_in_San_Francisco_cleaned.csv'
		CSV.foreach(filename, :headers => true) do |row|
			location = Location.find_by :description => row[2]
			location.update_attributes fun_facts: row[3] if location
		end
	end

	desc "Remove Moview With No Location Data"
	task remove_empty_location_movies: :environment do
		Movie.all.each do |m|
			if m.locations.count < 1
				puts "Deleting #{m.title}"
				Movie.delete m
			end
		end
	end

	desc "Fetch Movie Metadata From Rotten Tomatoes"
	# Should make sure it's ok to store RT data in our db since we are not calling from the client
	task rt_data: :environment do
		require 'httparty'
		require 'json'
		
		Movie.where("rt_id is NULL").each do |movie|
			url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=#{movie.title.gsub(' ','+')}&apikey=3s7vy9fz9bqhmdf8zmbtkm3s"
			puts "Finding #{movie.title}"
			r = HTTParty.get(url)
			r = JSON.parse r
			if r["total"] > 0
				r["movies"].each do |m|
					if m["title"] == movie.title
						puts "Found Match", m
						movie.update_attributes(
							rt_id: m["id"],
							mpaa_rating: m["mpaa_rating"], 
							critics_score: m["ratings"]["critics_score"], 
							audience_score: m["ratings"]["audience_score"], 
							synopsis: m["synopsis"], 
							poster_url: m["posters"]["detailed"]
						)

						# get clips
						if m['links']['clips']
							clips = JSON.parse(HTTParty.get("#{m['links']['clips']}?apikey=3s7vy9fz9bqhmdf8zmbtkm3s"))
							if clips["clips"].count > 0
								puts clips
								movie.update_attributes clip_thumb_url: clips["clips"][0]["thumbnail"], clip_url: clips["clips"][0]["links"]["alternate"]
							end
						end
					else
						puts "No Match"
					end
				end
			end
		end
	end
#rtkey 3s7vy9fz9bqhmdf8zmbtkm3s
end
