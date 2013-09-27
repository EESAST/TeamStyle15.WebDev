json.array!(@users) do |user|
  json.extract! user, :name, :email, :hashed_password, :salt, :true_name, :student_number, :team_id, :portait_path, :type
  json.url user_url(user, format: :json)
end
