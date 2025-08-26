module Controller
  module Api
    module PricesController

      def self.registered(app)

        app.get '/api/rental-locations/:id/rate-types' do

          Integer(params[:id]) rescue halt 400, { error: 'invalid rental_location_id' }.to_json

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


      end

    end
  end
end
