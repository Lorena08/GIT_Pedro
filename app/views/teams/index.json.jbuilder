json.array!(@teams) do |team|
  json.extract! team, :id, :description
  json.url team_url(team, format: :json)
end
