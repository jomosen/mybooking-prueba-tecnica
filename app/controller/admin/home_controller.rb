module Controller
  module Admin
    module HomeController

      def self.registered(app)

        #
        # Home page
        #
        app.get '/' do

          use_case = PageUseCase::Home::PageHomeUseCase.new(
            Repository::RentalLocationRepository.new,
            logger)
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
