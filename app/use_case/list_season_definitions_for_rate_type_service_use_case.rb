module UseCase
    
  class ListSeasonDefinitionsForRateTypeServiceUseCase

    include UseCase::Helper::ValidationHelper

    Result = Struct.new(:success?, :authorized?, :data, :message, keyword_init: true)

    def initialize(service, logger)
      @service = service
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
      @logger.debug "ListSeasonDefinitionsForRateTypeServiceUseCase - execute - data: #{data.inspect}"

      # Return the result
      return Result.new(success?: true, authorized?: true, data: data)
    end

    private

    def load_data(params)
      @service.retrieve(params)
    end

    def process_params(params)
      
      begin
        params[:rental_location_id] = validate_integer!(params[:rental_location_id], "invalid rental_location_id")
        params[:rate_type_id] = validate_integer!(params[:rate_type_id], "invalid rate_type_id")
        { valid: true, authorized: true }
      rescue Error::ValidationError => e
        { valid: false, authorized: true, message: e.message } 
      end
    end

  end
end
