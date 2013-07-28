json.array!(@teams) do |team|
  json.extract! team, :name, :captain_id
  json.url team_url(team, format: :json)
end
