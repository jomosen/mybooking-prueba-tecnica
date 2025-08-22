module Model
  #
  # It represents a season period
  #
  class SeasonPeriod
     include DataMapper::Resource
     storage_names[:default] = 'season_periods'

     property :id, Serial
     belongs_to :season, 'Model::Season', required: true

     property :start_date, Date, required: true
     property :end_date, Date, required: true

  end
end
