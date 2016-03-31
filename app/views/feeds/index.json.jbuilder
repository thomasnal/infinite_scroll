json.array! @feeds do |feed|
  json.extract! feed, :content, :created_at
end
