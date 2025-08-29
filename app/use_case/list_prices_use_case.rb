module UseCase
    
  class ListPricesUseCase

    include UseCase::Helper::ValidationHelper

    Result = Struct.new(:success?, :authorized?, :data, :message, keyword_init: true)

    def initialize(service, time_measurement_mapper, logger)
      @service = service
      @time_measurement_mapper = time_measurement_mapper
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
      @logger.debug "ListPricesUseCase - execute - data: #{data.inspect}"

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
        params[:time_measurement] = validate_time_measurement!(params[:time_measurement])
        params[:season_definition_id], params[:season_id] = validate_season(params[:season_definition_id], params[:season_id])
        
        { valid: true, authorized: true }
      rescue Error::ValidationError => e
        { valid: false, authorized: true, message: e.message } 
      end
    end
    
    # Valdia time_measurement y lo pasa a entero para persistir
    def validate_time_measurement!(time_measurement)
      time_measurement = @time_measurement_mapper.to_db(time_measurement)
      raise Error::ValidationError, "invalid time_measurement" if time_measurement.nil?

      time_measurement
    end

    # Valida la temporada teniendo en cuenta los dos datos que la componen y que deben estar los dos o ninguno
    def validate_season(season_definition_id, season_id)
      season_definition_id = season_definition_id.presence
      season_id = season_id.presence

      if season_definition_id
        validate_integer!(season_definition_id, "invalid season_definition_id")
        raise Error::ValidationError, "season_id is required when season_definition_id is present" if season_id.nil?
        validate_integer!(season_id, "invalid season_id")
      end
      
      [season_definition_id, season_id]
    end

  end
end
