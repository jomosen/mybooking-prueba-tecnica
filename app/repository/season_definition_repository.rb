module Repository
  class SeasonDefinitionRepository < Repository::BaseRepository
    def initialize
      super(Model::SeasonDefinition)
    end
  end
end
