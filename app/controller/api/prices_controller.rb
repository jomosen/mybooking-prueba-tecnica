module Controller
  module Api
    module PricesController

      def self.registered(app)

        app.get '/api/rental-locations/:rental_location_id/rate-types' do

          service = Service::ListRateTypesForRentalLocationService.new
          use_case = UseCase::ListRateTypesForRentalLocationServiceUseCase.new(service, logger)
          result = use_case.perform(params)

          if result.success?
            content_type :json
            result.data.to_json
          elsif !result.authorized?
            halt 401
          else
            halt 400, result.message.to_json
          end
        end

        app.get '/api/rate-types/:rate_type_id/season-definitions' do

          service = Service::ListSeasonDefinitionsForRateTypeService.new
          use_case = UseCase::ListSeasonDefinitionsForRateTypeServiceUseCase.new(service, logger)
          result = use_case.perform(params)

          if result.success?
            content_type :json
            result.data.to_json
          elsif !result.authorized?
            halt 401
          else
            halt 400, result.message.to_json
          end
        end

      end

    end
  end
end
