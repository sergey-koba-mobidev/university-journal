json.array!(@semesters) do |semester|
  json.extract! semester, :id, :year, :pos
  json.url semester_url(semester, format: :json)
end
