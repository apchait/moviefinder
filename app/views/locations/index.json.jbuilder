json.array!(@locations) do |location|
  json.extract! location, :id, :formatted_address, :lat, :lng, :ne_lat, :ne_lng, :sw_lat, :sw_lng, :movie_id
  json.url location_url(location, format: :json)
end
