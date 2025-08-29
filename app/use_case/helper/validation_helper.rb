module UseCase
  module Helper

    module ValidationHelper

      def validate_integer!(value, message)
        Integer(value)
      rescue
        raise Errors::ValidationError, message
      end

    end
    
  end
end
