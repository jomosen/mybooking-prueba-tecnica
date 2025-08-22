module Repository
  class PriceDefinitionRepository < Repository::BaseRepository
    def initialize
      super(Model::PriceDefinition)
    end
  end
end
