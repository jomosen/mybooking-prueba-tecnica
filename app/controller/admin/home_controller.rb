module Controller
  module Admin
    module HomeController

      def self.registered(app)

        #
        # Home page
        #
        app.get '/' do

          rental_location_repository = Repository::RentalLocationRepository.new
          use_case = PageUseCase::Home::PageHomeUseCase.new(rental_location_repository, logger)
          result = use_case.perform(params)

          @title = "Home page"
          @rental_locations = result.data

          if result.success?
            @message = result.data
            erb :index
          else
            @message = result.message
            erb :error_page
          end

        end

      end
    end
  end
end
