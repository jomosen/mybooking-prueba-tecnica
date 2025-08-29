module UseCase
    
  class ImportPricesUseCase

    Result = Struct.new(:success?, :authorized?, :data, :message, keyword_init: true)

    def initialize(import_prices_service:, import_result_decorator:, logger:)
      @service = import_prices_service
      @import_result_decorator = import_result_decorator
      @logger = logger
    end

    def perform(data_source)

      prices = data_source.read()

      batch = Dto::Import::PricesBatchDto.new(prices)
      
      initial_validation = perform_initial_validation(batch)

      # Check valid
      unless initial_validation[:valid]
        return Result.new(success?: false, authorized?: true, message: initial_validation[:message])
      end

      # Check authorization
      unless initial_validation[:authorized]
        return Result.new(success?: true, authorized?: false, message: 'Not authorized')
      end

      result = @service.process_batch(batch)

      result_decorated = @import_result_decorator.new(result)
      summary = result_decorated.summary

      # Return the result
      return Result.new(success?: true, authorized?: true, data: summary)

    end

    private

    def perform_initial_validation(batch)

      unless batch.valid?
        return { valid: false, authorized: true, message: batch.errors }
      end

      return { valid: true, authorized: true }
    end

  end
end
