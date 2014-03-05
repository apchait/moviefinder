class Location < ActiveRecord::Base
	belongs_to :movie

	default_scope where("lat is not NULL AND lng is not NULL")

	def geojson
		# Lat Long backwards becasue
		{
			"type"=> "Feature",
			"geometry"=> {
			  "type"=> "Point",
			  "coordinates"=> [self.lng,self.lat]
			},
			"properties"=> {
			  "title"=> self.description,
			  "description"=> self.fun_facts,
			  "marker-color"=> "#fc4353",
			  "marker-size"=> "large",
			  "marker-symbol"=> "cinema"
			}
		}
	end
end
