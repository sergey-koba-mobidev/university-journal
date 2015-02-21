json.array!(@disciplines) do |discipline|
  json.extract! discipline, :id, :title, :user_id
  json.url discipline_url(discipline, format: :json)
end
