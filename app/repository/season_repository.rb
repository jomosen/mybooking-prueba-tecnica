module Repository
  class SeasonRepository < Repository::BaseRepository
    def initialize
      super(Model::Season)
    end
  end
end
