module Model
  class CategoryRentalLocationRateType
     include DataMapper::Resource
     storage_names[:default] = 'category_rental_location_rate_types'

     property :id, Serial
     belongs_to :category, 'Model::Category', required: true
     belongs_to :rental_location, 'Model::RentalLocation', required: true
     belongs_to :rate_type, 'Model::RateType', required: true

  end
end
