json.extract! lost_form, :id, :current_date, :lost_date, :phone, :owner_name, :pet_name, :collar, :tags, :color, :species, :breed, :gender, :size, :spayed_neutered, :found, :comments, :created_at, :updated_at
json.url lost_form_url(lost_form, format: :json)
