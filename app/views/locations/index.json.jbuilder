json.array!(@locations) do |location|
  json.extract! location, :id, :formatted_address, :lat, :long, :ne_lat, :ne_long, :sw_lat, :sw_long, :movie_id
  json.url location_url(location, format: :json)
end
