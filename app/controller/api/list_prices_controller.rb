module Controller
  module Api
    module ListPricesController

      def self.registered(app)

        app.get '/api/rental-locations/:rental_location_id/rate-types' do
          use_case = UseCase::ListRateTypesForRentalLocationServiceUseCase.new(
            Service::ListPrices::ListRateTypesForRentalLocationService.new, logger)
          result = use_case.perform(params)
          json_response(result)
        end

        app.get '/api/rate-types/:rate_type_id/season-definitions' do
          use_case = UseCase::ListSeasonDefinitionsForRateTypeServiceUseCase.new(
            Service::ListPrices::ListSeasonDefinitionsForRateTypeService.new, logger)
          result = use_case.perform(params)
          json_response(result)
        end

        app.get '/api/season-definitions/:season_definition_id/seasons' do
          use_case = UseCase::ListSeasonsForSeasonDefinitionServiceUseCase.new(
            Service::ListPrices::ListSeasonsForSeasonDefinitionService.new, logger)
          result = use_case.perform(params)
          json_response(result)
        end

        app.get '/api/prices' do
          use_case = UseCase::ListPricesUseCase.new(
            Service::ListPrices::ListPricesService.new, Service::ListPrices::Mapper::TimeMeasurementMapper, logger)
          result = use_case.perform(params)

          if result.success?
            content_type :json

            # Devolvemos una estructura de datos lista para representar en la vista.
            # Lo hago aquí y no en el caso de uso para no acoplarlo a una presentación concreta.
            Presenter::ListPricesPivotPresenter.new(result.data).as_table.to_json
          else
            json_response(result)
          end
        end

        app.helpers do
          def json_response(result)
            content_type :json

            if result.success?
              result.data.to_json
            elsif !result.authorized?
              halt 401, { error: "Unauthorized" }.to_json
            else
              halt 400, { error: result.message }.to_json
            end
          end
        end

      end
    end
  end
end
