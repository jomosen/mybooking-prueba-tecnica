module Model
  #
  # It represents a rate type
  #
  class RateType
     include DataMapper::Resource
     storage_names[:default] = 'rate_types'

     property :id, Serial
     property :name, String, length: 255, required: true

  end
end
