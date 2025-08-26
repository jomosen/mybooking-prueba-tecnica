module PageUseCase
  module Home
    #
    # Page use case to modify the dates of a booking.
    #
    class PageHomeUseCase

      Result = Struct.new(:success?, :authorized?, :data, :message, keyword_init: true)

      #
      # Initialize the use case
      #
      # @param [Logger] logger
      #
      def initialize(rental_location_repository, logger)
        @rental_location_repository = rental_location_repository
        @logger = logger
      end

      #
      # Perform the use case
      #
      # @param [User] user
      # @param [Integer] booking_id
      #
      # @return [Result]
      #
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

        data = self.load_data
        @logger.debug "PageHomeUseCase - execute - data: #{data.inspect}"

        # Return the result
        return Result.new(success?: true, authorized?: true, data: data)

      end

      private

      def load_data
        @rental_location_repository.find_all(order: [:name.asc])
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
end
