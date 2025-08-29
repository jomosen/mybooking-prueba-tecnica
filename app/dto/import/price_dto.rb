module Dto
  module Import

    class PriceDto
      
      attr_reader :errors, :attributes

      def initialize(row)
        @errors = []

        @attributes = {
          category_id:        to_integer(row[:category_id],        name: "category_id",        errors: @errors),
          rental_location_id: to_integer(row[:rental_location_id], name: "rental_location_id", errors: @errors),
          rate_type_id:       to_integer(row[:rate_type_id],       name: "rate_type_id",       errors: @errors),
          season_id:          blank?(row[:season_id]) ? nil : to_integer(row[:season_id], name: "season_id", errors: @errors),
          time_measurement:   to_integer(row[:time_measurement], name: "time_measurement", errors: @errors),
          units:              to_integer(row[:units],              name: "units",              errors: @errors),
          price:              to_decimal(row[:price],              name: "price",              errors: @errors),
          included_km:        to_integer(row.fetch(:included_km, 0),     name: "included_km",    errors: @errors),
          extra_km_price:     to_decimal(row.fetch(:extra_km_price, 0.0), name: "extra_km_price", errors: @errors)
        }
      end

      def valid?
        @errors.empty?
      end

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end

      def to_string(value, name: nil, errors: nil)
        s = value.to_s.strip
        if errors && s.empty?
          errors << "#{name} is required"
        end
        s
      end

      def to_integer(value, name: nil, errors: nil)
        Integer(to_string(value, name: name, errors: errors))
      rescue ArgumentError
        errors << "#{name} must be integer" if errors
        nil
      end

      def to_decimal(value, name: nil, errors: nil)
        BigDecimal(to_string(value, name: name, errors: errors))
      rescue ArgumentError
        errors << "#{name} must be decimal" if errors
        nil
      end

    end
    
  end
end