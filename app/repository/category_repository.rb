module Repository
  class CategoryRepository < Repository::BaseRepository
    def initialize
      super(Model::Category)
    end
  end
end
