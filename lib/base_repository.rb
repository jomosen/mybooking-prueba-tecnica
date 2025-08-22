module Repository
  #
  # Base clase for all repositories
  #
  # For now it is implemented using DataMapper but it could be migrated to Sequel easily
  #
  class BaseRepository

    #
    # Constructor
    #
    # @param model_class [Class] The model class
    #
    def initialize(model_class)
      @model_class = model_class
    end

    #
    # Get the model class
    #
    # @return [Class] The model class
    #
    def model_class
      @model_class
    end

    #
    # Get the entity by id
    #
    # @param id [Integer, String, Hash] The entity id
    #
    def find_by_id(ids)
      if ids.is_a?(Hash)
        validate_keys(ids)
        @model_class.first(ids)
      else
        @model_class.get(ids)
      end
    end

    #
    # Get the entity by id with lock
    #
    # @param id [Integer, String, Hash] The entity id
    #
    def find_by_id_with_lock(ids)
      keys = {}
      if ids.is_a?(Hash)
        keys = ids
      else
        keys[@model_class.key.first.name] = ids
      end
      validate_keys(keys)
      @model_class.first(keys, with_locking: true)
    end

    #
    # Create a new entity
    #
    # @param entity [Hash, DataMapper::Resource] The entity to create
    # @return [DataMapper::Resource] the created record
    #
    def create(entity)
      if entity.is_a?(Hash)
        record = @model_class.new(entity)
        record.save
        record
      elsif entity.is_a?(@model_class)
        entity.save
        entity
      else
        raise ArgumentError, "Invalid entity type"
      end
    end

    #
    # Update an entity
    #
    # @param id [Integer, String, Hash] The entity id
    # @param entity_or_attributes [DataMapper::Resource, Hash] The entity to update
    #
    def update(ids, entity_or_attributes)

      if entity_or_attributes.is_a?(DataMapper::Resource)
        entity_or_attributes.save
        return entity_or_attributes
      elsif entity_or_attributes.is_a?(Hash)
        record = self.find_by_id(ids)
        raise ArgumentError, "Record not found" unless record
        record.update(entity_or_attributes)
        return record
      end

    end

    #
    # Delete an entity
    #
    # @param id [DataMapper::Resource, Integer, String, Hash] The entity id or the entity
    #
    def delete(ids_or_entity)

      if ids_or_entity.is_a?(DataMapper::Resource)
        ids_or_entity.destroy
        true
      else
        # Search for the record
        record = self.find_by_id(ids_or_entity)
        raise ArgumentError, "Record not found" unless record
        record.destroy
        true
      end

    end

    #
    # Save the entity
    #
    # @param entity [DataMapper::Resource] The entity
    #
    def save(entity)
      if entity.new?
        create(entity)
      else
        entity.save
        #update(entity.id, entity)
      end
    end

    #
    # Reload the entity
    #
    def reload(entity)
      if entity.is_a?(DataMapper::Resource)
        entity.reload
      end
    end

    #
    # Find all the entities
    #
    # @param opts [Hash] optional parameters for the query
    # @option opts [Array<Symbol>, Symbol] :fields the fields to select
    # @option opts [Hash] :conditions the conditions to filter the records
    # @option opts [Symbol, Array<Symbol>] :order the field(s) to order by
    # @option opts [Integer] :limit the maximum number of records to return
    # @option opts [Integer] :offset the number of records to skip
    # @return [Array<DataMapper::Resource>] the found records
    #
    def find_all(opts={})
      @model_class.all(opts)
    end

    #
    # Find all the entities by condition
    #
    # @param condition [Conditions::Comparison] The condition
    # @return [Array<DataMapper::Resource>] the found records
    #
    def find_by_condition(condition)
      condition.build_datamapper(@model_class)
    end

    #
    # Count the total number of entities by condition
    #
    # @param condition [Conditions::Comparison] The condition
    # @return [Integer] the count of records
    def count_by_condition(condition)
      find_by_condition(condition).count
    end

    #
    # Find all the entities by condition
    #
    # @param condition [Conditions::Comparison] The condition
    # @return [Array<DataMapper::Resource>] the found records
    #
    def find_all_by_condition(condition, opts={})
      find_by_condition(condition).all(opts)
    end

    #
    # Find the first entity
    #
    # @param opts [Hash] optional parameters for the query
    #
    def first(opts={})
      @model_class.first(opts)
    end

    #
    # Find the first entity with locking
    #
    # @param opts [Hash] optional parameters for the query
    #
    def first_with_locking(opts={})
      opts.store(:with_locking, true)
      @model_class.first(opts)
    end

    #
    # Count the total number of entities
    #
    # @param opts [Hash] optional parameters for the query
    # @option opts [Hash] :conditions the conditions to filter the records
    # @return [Integer] the count of records
    #
    def count(opts={})
      @model_class.count(opts)
    end

    #
    # Check if there are any entities
    #
    # @param opts [Hash] optional parameters for the query
    # @option opts [Hash] :conditions the conditions to filter the records
    # @return [Boolean] true if there is at least one record, false otherwise
    #
    def any?(opts={})
      !@model_class.first(opts).nil?
    end

    private

    def validate_keys(ids)
      primary_keys = @model_class.key.map(&:name).map(&:to_sym)
      unless ids.keys.all? { |key| primary_keys.include?(key) }
        raise ArgumentError, "Invalid keys provided"
      end
    end

  end
end
