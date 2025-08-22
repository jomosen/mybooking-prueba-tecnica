module Repository
  class RentalLocationRepository < Repository::BaseRepository
    def initialize
      super(Model::RentalLocation)
    end
  end
end
