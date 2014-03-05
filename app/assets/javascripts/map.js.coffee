# Cache movies and use local datasource
# 

jQuery ->
	$('form').submit (event) ->
		event.preventDefault()
		console.log event

	getMovie = (title) ->
		console.log title
		url =  '/movies/query/' + title + '.json'
		$.get url, (response) ->			
			if response
				# Geocode the locations
				location = response.locations[0]['description']
				console.log location + " San Francisco, CA"
				geocoder.query(location + " San Francisco, CA", geocoded)
				$.each response, (i,v) ->
					# Fill info
					$("#" + i).html(v)
			

	# $('#query').on 'change', (event) ->
		  #   console.log event

	$( "#query" ).autocomplete
		source: "/movies/autocomplete.json",
		minLength: 0,
		select: ( event, ui ) ->
			getMovie(ui.item.value)

	map = L.mapbox.map('map', 'examples.map-9ijuk24y')
	geocoder = L.mapbox.geocoder('examples.map-vyofok3q')

	geocoded = (err, data) ->
		map.fitBounds(data.lbounds)
		console.log data

		L.mapbox.featureLayer
			# this feature is in the GeoJSON format: see geojson.org
			# for the full specification
			type: 'Feature',
			geometry: {
				type: 'Point',
				# coordinates here are in longitude, latitude order because
				# x, y is the standard for GeoJSON and many formats
				coordinates: [data.latlng[1], data.latlng[0]]
			},
			properties: {
				title: 'A Single Marker',
				description: 'Just one of me',
				# one can customize markers by adding simplestyle properties
				#http://mapbox.com/developers/simplestyle/
				'marker-size': 'large',
				'marker-color': '#f0a'
			}
		.addTo(map)

	geocoder.query('555 Market St.', geocoded)