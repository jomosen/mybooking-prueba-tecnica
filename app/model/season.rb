module Model
  #
  # It represents a season definition
  #
  class Season
     include DataMapper::Resource
     storage_names[:default] = 'seasons'

     property :id, Serial
     belongs_to :season_definition, 'Model::SeasonDefinition', required: true
     property :name, String, length: 255

  end
end
