## Movie Finder
A web app that shows on a map where movies have been filmed in San Francisco. The user can search for movie titles via an autocomplete search field and see a map of film shoot locations.

The app is built with the Ruby on Rails framework. In order for the client to only interact with the apps backend instead of third party serviced film shoot location data was pulled from [DataSF:Film Locations](https://data.sfgov.org/Arts-Culture-and-Recreation-/Film-Locations-in-San-Francisco/yitu-d5am) and seeded into the local database.

### Work done
After setting up the rails app, models were created for the various elements contained in the data. 

####Models
* Movie - To store movie metadata, has many locations, belongs to and has many personalities.
* Location - To store location data, belongs to a movie.
* Personality - To store data on persons, Actor/Writer/Director inherit from this model. Belongs to and has many movies.

Most of the unique code is contained in four files
* [db/seeds.rb](https://github.com/apchait/moviefinder/blob/master/db/seeds.rb) - Parses DataSF CSV and creates instances and their relationships.
* [lib/tasks/script.rake](https://github.com/apchait/moviefinder/blob/master/lib/tasks/script.rake) - Rakefile for assorted tasks such as geocoding address and fetching imdb info for personalities.
* [app/assets/javascripts/map.js.coffee](https://github.com/apchait/moviefinder/blob/master/app/assets/javascripts/map.js.coffee) - Initializes the map, handles autocomplete queries and display of resulting data.
* [app/assets/views/map/index.html.erb](https://github.com/apchait/moviefinder/blob/master/app/assets/views/map/index.html.erb) - HTML view for the map page.

####Services Used by the Backend
* Location data came in the form of descriptive address strings thus had be geocoded with the [Google Maps Geocoding API](https://developers.google.com/maps/documentation/geocoding/) into lat long pairs.
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/Home) was used to gather movie specific metadata.
* [The Movie DB API](http://docs.themoviedb.apiary.io/) was used to fetch IMDB id's of personalities

####Front End Libraries
* [MapBox JS](https://www.mapbox.com/mapbox.js) - Interactive mapping library to show the map and place markers
* [Bootstrap](http://getbootstrap.com/) - For it's CSS framework and elements
* [Endless Bootstrap Theme](https://wrapbootstrap.com/theme/endless-responsive-admin-template-WB00J6977) - A few UI elements from this template were used for the nav and sidebar.