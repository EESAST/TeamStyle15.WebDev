json.array!(@messages) do |message|
  json.extract! message, :user_id, :type, :content, :read, :text
  json.url message_url(message, format: :json)
end
