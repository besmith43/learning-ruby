json.extract! course, :id, :owner, :course_number, :course_name, :created_at, :updated_at
json.url course_url(course, format: :json)