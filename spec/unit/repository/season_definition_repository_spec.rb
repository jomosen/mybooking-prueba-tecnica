require_relative '../../spec_helper'
RSpec.describe Repository::SeasonDefinitionRepository do
  describe '#initialize' do
    it 'initializes with Model::SeasonDefinition model' do
      repository = Repository::SeasonDefinitionRepository.new
      expect(repository.model_class).to eq(Model::SeasonDefinition)
    end
  end
end
