module Dto
  module Import
    module Validator
                
      module SchemaValidator

        EXPECTED_KEYS = %i[
          category_id
          rental_location_id
          rate_type_id
          season_id
          time_measurement
          units
          price
          included_km
          extra_km_price
        ].freeze

        module_function

        def validate_schema!(items)
          if items.nil? || items.empty?
            raise "No items provided"
          end

          unless items.is_a?(Array) && items.first.is_a?(Hash)
            raise "Import schema not valid: expected Array<Hash>"
          end

          # Validación de claves
          keys = items.first.keys
          if keys != EXPECTED_KEYS
            raise "Expected #{EXPECTED_KEYS.inspect}, got #{keys.inspect}"
          end

          # Comprobamos que haya coherencia en todas las filas
          items.each_with_index do |item, i|
            raise "Invalid item schema at index #{i}: Expected keys #{EXPECTED_KEYS.inspect}, got #{item.keys.inspect}" unless item.keys == EXPECTED_KEYS
          end

          true
        end
      end 

    end
  end
end