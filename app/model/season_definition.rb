module Model
  #
  # It represents a season definition
  #
  class SeasonDefinition
     include DataMapper::Resource
     storage_names[:default] = 'season_definitions'

     property :id, Serial
     property :name, String, length: 255, required: true

  end
end
