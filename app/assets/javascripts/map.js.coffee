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
				console.log response.locations
				map.featureLayer.setGeoJSON(response.locations)
				map.featureLayer.on 'mouseover', (e) ->
					e.layer.openPopup()
				map.featureLayer.on 'mouseout', (e) ->
					e.layer.closePopup()

				map.fitBounds(map.featureLayer.getBounds()).setZoom( 15 )
				$.each response, (i,v) ->
					# Fill info
					$("#" + i).html(v)

	$( "#query" ).autocomplete
		source: "/movies/autocomplete.json",
		minLength: 0,
		select: ( event, ui ) ->
			getMovie(ui.item.value)

	map = L.mapbox.map('map', 'examples.map-9ijuk24y').setView([37.75,-122.45], 12);