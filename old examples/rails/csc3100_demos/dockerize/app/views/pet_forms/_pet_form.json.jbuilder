json.extract! pet_form, :id, :date, :date_since, :phone, :owner_name, :pet_name, :color, :collar, :tags, :breed, :gender, :size, :spayed_neutered, :area, :comments, :lost_found, :pending, :created_at, :updated_at
json.url pet_form_url(pet_form, format: :json)
