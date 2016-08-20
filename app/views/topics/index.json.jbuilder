json.array!(@topics) do |topic|
  json.extract! topic, :id, :topic, :due
  json.url topic_url(topic, format: :json)
end
