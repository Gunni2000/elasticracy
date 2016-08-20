json.array!(@arguments) do |argument|
  json.extract! argument, :id, :statement, :validity, :topic_id
  json.url argument_url(argument, format: :json)
end
