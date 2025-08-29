module Dto
  module Import
    class PricesBatchDto
      attr_reader :errors, :prices

      def initialize(import_items)
        @errors = []
        @prices  = []

        begin

          Validator::SchemaValidator.validate_schema!(import_items)

          import_items.each_with_index do |item, i|
            item_dto = PriceDto.new(item)
            if item_dto.valid?
              @prices << item_dto
            else
              @errors << { item_index: i, errors: item_dto.errors }
            end
          end
          
        rescue => e
          @errors << { errors: [e.message] }
        end
      end

      def valid?
        @errors.empty?
      end

    end
  end
end