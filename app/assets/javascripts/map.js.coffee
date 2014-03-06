# Cache movies and use local datasource
# 

jQuery ->
	$('form').submit (event) ->
		event.preventDefault()
		console.log event

	getMovie = (title) ->
		url =  '/movies/query/' + title + '.json'
		$.get url, (response) ->			
			if response
				console.log response
				$("#query").val('')
				map.featureLayer.setGeoJSON(response.locations)
				map.featureLayer.on 'mouseover', (e) ->
					e.layer.openPopup()
				map.featureLayer.on 'mouseout', (e) ->
					e.layer.closePopup()

				map.fitBounds(map.featureLayer.getBounds()).setZoom( 15 )
				

				$.each ["title", "release_year"], (i,v) ->
					$("#" + v).html(response[v])

				$.each ["actors", "writers", "directors"], (i,v) ->
					$.each response[v], (j,personality) ->
						if personality["name"]
							if personality["imdb_id"]
								$("#" + v).append $("<a>").attr("href", "http://www.imdb.com/name/" + personality["imdb_id"]).attr("target", "_blank").html(personality["name"] + " ")
							else
								$("#" + v).append($("<span>").html(personality["name"]))
							
							$("#" + v).append("<br/>")


				$('#rt-url').attr('href', "http://www.rottentomatoes.com/m/" + response["rt_id"])
				$('#poster').attr('src', response["poster_url"])

	$( "#query" ).autocomplete({
	    source: "/movies/autocomplete.json",
		minLength: 0,
		select: ( event, ui ) ->
			getMovie(ui.item.value)  
	}).focus () ->
		$(this).trigger('keydown.autocomplete')

	$('#search-btn').click () ->
		getMovie($("#query").val())

	$("#see-all").click (e) ->
		$("#query").autocomplete("search")

	map = L.mapbox.map('map', 'examples.map-9ijuk24y').setView([37.75,-122.45], 12)