module Repository
  class PriceRepository < Repository::BaseRepository
    def initialize
      super(Model::Price)
    end
  end
end
