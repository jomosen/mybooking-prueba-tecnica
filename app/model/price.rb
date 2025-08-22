module Model
  #
  # It represents a price
  #
  class Price
     include DataMapper::Resource
     storage_names[:default] = 'prices'

     property :id, Serial
     belongs_to :price_definition, 'Model::PriceDefinition', required: true
     belongs_to :season, 'Model::Season', required: false

     property :time_measurement, Enum[:months, :days, :hours, :minutes], :default => :days
     property :units, Integer
     property :price, Decimal, precision: 10, scale: 2

     property :included_km, Integer
     property :extra_km_price, Decimal, precision: 10, scale: 2


  end
end
