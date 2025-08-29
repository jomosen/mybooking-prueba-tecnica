module Controller
  module Api
    module ImportPricesController

      def self.registered(app)

        app.post '/api/prices/import/csv' do
          
          file = params[:csv_file][:tempfile]

          begin
            data_source = Service::ImportPrices::CsvDataSource.new(
              file,
              Service::ImportPrices::Mapper::PriceRowMapper
            )
          rescue => e
            halt 400, { error: e.message }.to_json
          end

          import_prices_service = Service::ImportPrices::ImportPricesService.new(
            crlrt_repository: Repository::CategoryRentalLocationRateTypeRepository.new, 
            pd_repository: Repository::PriceDefinitionRepository.new,
            units_policy: Policy::AllowedUnitsPolicy.new(Service::ListPrices::Mapper::TimeMeasurementMapper),
            price_repository: Repository::PriceRepository.new,
            logger: logger
          )

          use_case = UseCase::ImportPricesUseCase.new(
            import_prices_service: import_prices_service, 
            import_result_decorator: Service::ImportPrices::Decorator::ImportResultDecorator,
            logger: logger
          )

          result = use_case.perform(data_source)

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
