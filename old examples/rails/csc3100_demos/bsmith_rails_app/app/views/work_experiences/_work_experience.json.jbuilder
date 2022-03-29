json.extract! work_experience, :id, :owner, :start_date, :end_date, :name, :description, :created_at, :updated_at
json.url work_experience_url(work_experience, format: :json)