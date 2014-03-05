json.array!(@actors) do |actor|
  json.extract! actor, :id
  json.url actor_url(actor, format: :json)
end
