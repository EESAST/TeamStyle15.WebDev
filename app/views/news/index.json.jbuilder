json.array!(@news) do |news|
  json.extract! news, :title, :text
  json.url news_url(news, format: :json)
end
