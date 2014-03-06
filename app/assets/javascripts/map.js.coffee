jQuery ->
	# Stop form from reloading the page
	$('form').submit (event) ->
		event.preventDefault()

	# Call getMovie with a title from the search input to issue query on database
	# If successful response contains Movie data along with personalities
	getMovie = (title) ->
		url =  '/movies/query/' + title + '.json'
		$.get url, (response) ->			
			if response
				console.log response
				# Clear the search bar
				$("#query").val('')
				# Set the markers on the map and zoom to fit them all
				map.featureLayer.setGeoJSON(response.locations)
				map.featureLayer.on 'mouseover', (e) ->
					e.layer.openPopup()
				map.featureLayer.on 'mouseout', (e) ->
					e.layer.closePopup()
				map.fitBounds(map.featureLayer.getBounds()).setZoom( 15 )
				
				# Add movie data to left bar
				$.each ["title", "release_year"], (i,v) ->
					$("#" + v).html(response[v])
				# Add the RT link if it exists, google search the link into RT if not
				if response["rt_id"]
					href = "http://www.rottentomatoes.com/m/" + response["rt_id"]
				else
					href = "https://www.google.com/#q=site:www.rottentomatoes.com%20" +  encodeURI(response['title'])
				$("#title-link").attr('href', href)
				# Add a poster image that links back to the Rotten Tomatoes page
				$('#rt-url').attr('href', href)
				$('#poster').attr('src', response["poster_url"])

				# Add personalities in their respective sections with links to imdb profiles
				$.each ["actors", "writers", "directors"], (i,v) ->
					$("#" + v).html("")
					$.each response[v], (j,personality) ->
						if personality["name"]
							if personality["imdb_id"]
								$("#" + v).append $("<a>").attr("href", "http://www.imdb.com/name/" + personality["imdb_id"]).attr("target", "_blank").html(personality["name"] + " ")
							else
								$("#" + v).append($("<span>").html(personality["name"]))
							$("#" + v).append("<br/>")

	# Initialize jQuery autocomplete on the search bar
	# Source will be called with params["term"] containing the search term on submit
	# REFACTOR - Cache the list of movies in the client to use as source instead of querying the db everytime
	$( "#query" ).autocomplete({
	    source: "/movies/autocomplete.json",
		minLength: 0,
		select: ( event, ui ) ->
			getMovie(ui.item.value)  
	}).focus () ->
		$(this).trigger('keydown.autocomplete')

	# Manual click on search button sends query
	$('#search-btn').click () ->
		getMovie($("#query").val())

	# See all options button activates autocomplete without a query to show all options
	$("#see-all").click (e) ->
		$("#query").val("")
		$("#query").autocomplete("search")

	# Initiate the MapBox map on page ready
	map = L.mapbox.map('map', 'examples.map-9ijuk24y').setView([37.75,-122.45], 12)