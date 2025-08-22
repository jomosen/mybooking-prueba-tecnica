require_relative '../../spec_helper'
RSpec.describe Repository::SeasonRepository do
  describe '#initialize' do
    it 'initializes with Model::Season model' do
      repository = Repository::SeasonRepository.new
      expect(repository.model_class).to eq(Model::Season)
    end
  end
end
