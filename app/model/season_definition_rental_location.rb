module Model
  class SeasonDefinitionRentalLocation
     include DataMapper::Resource
     storage_names[:default] = 'season_definition_rental_locations'

     property :id, Serial
     belongs_to :season_definition, 'Model::SeasonDefinition', required: true
     belongs_to :rental_location, 'Model::RentalLocation', required: true

  end
end
