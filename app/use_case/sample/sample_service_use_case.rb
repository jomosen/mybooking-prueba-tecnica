module UseCase
  module Sample
    #
    # Sample use case to demonstrate the structure of Injection of Dependencies
    #
    class SampleServiceUseCase

      Result = Struct.new(:success?, :authorized?, :data, :message, keyword_init: true)

      #
      # Initialize the use case
      #
      # @param [Service::ListPricesService] list_prices_service
      # @param [Logger] logger
      #
      def initialize(list_prices_service, logger)
        @list_prices_service = list_prices_service
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
        @logger.debug "SampleServiceUseCase - execute - data: #{data.inspect}"

        # Return the result
        return Result.new(success?: true, authorized?: true, data: data)

      end

      private

      def load_data

        @list_prices_service.retrieve

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
