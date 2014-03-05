jQuery ->
	$('form').submit (event) ->
		event.preventDefault()
		console.log event

	getMovie = (title) ->
		console.log title
		url =  '/movies/query/' + title + '.json'
		$.get url, (response) ->
			if response
				$.each response, (i,v) ->
					# Fill info
					$("#" + i).html(v)
			

    # $('#query').on 'change', (event) ->
		  #   console.log event

	$( "#query" ).autocomplete
	    source: "/movies/titles.json",
	    minLength: 0,
	    select: ( event, ui ) ->
	        getMovie(ui.item.value)