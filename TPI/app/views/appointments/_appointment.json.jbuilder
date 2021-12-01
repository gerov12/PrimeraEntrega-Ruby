json.extract! appointment, :id, :date, :surname, :name, :phone, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
