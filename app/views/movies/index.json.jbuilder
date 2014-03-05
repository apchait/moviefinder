json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :release_year, :fun_facts, :director_id
  json.url movie_url(movie, format: :json)
end
