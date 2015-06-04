json.array!(@stocked_files) do |stocked_file|
  json.extract! stocked_file, :id, :original_name, :hash
  json.url stocked_file_url(stocked_file, format: :json)
end
