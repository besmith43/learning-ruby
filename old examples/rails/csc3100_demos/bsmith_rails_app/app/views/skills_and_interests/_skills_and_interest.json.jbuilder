json.extract! skills_and_interest, :id, :owner, :skill_name, :skill_description, :created_at, :updated_at
json.url skills_and_interest_url(skills_and_interest, format: :json)