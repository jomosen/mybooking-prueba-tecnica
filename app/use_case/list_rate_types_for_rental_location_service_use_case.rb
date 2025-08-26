module UseCase
    
  class ListRateTypesForRentalLocationServiceUseCase

    Result = Struct.new(:success?, :authorized?, :data, :message, keyword_init: true)

    def initialize(list_rate_types_for_rental_location_service, logger)
      @list_rate_types_for_rental_location_service = list_rate_types_for_rental_location_service
      @logger = logger
    end

    def perform(params)

      processed_params = process_params(params)

      # Check valid
      unless processed_params[:valid]
        return Result.new(success?: false, authorized?: true, message: processed_params[:message])
      end

      # Check authorization
      unless processed_params[:authorized]
        return Result.new(success?: true, authorized?: false, message: 'Not authorized')
      end

      data = self.load_data(params)
      @logger.debug "ListRateTypesForRentalLocationServiceUseCase - execute - data: #{data.inspect}"

      # Return the result
      return Result.new(success?: true, authorized?: true, data: data)

    end

    private

    def load_data(params)

      @list_rate_types_for_rental_location_service.retrieve_by_rental_location(params[:id])

    end

    #
    # Process the parameters
    #
    # @return [Hash]
    #
    def process_params(params)

      return { valid: true, authorized: true }

    end

  end
end
