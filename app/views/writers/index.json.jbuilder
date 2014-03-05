json.array!(@writers) do |writer|
  json.extract! writer, :id
  json.url writer_url(writer, format: :json)
end
