module Model
  #
  # It represents a rental location
  #
  class RentalLocation
     include DataMapper::Resource
     storage_names[:default] = 'rental_locations'

     property :id, Serial
     property :name, String, length: 255, required: true

  end
end
