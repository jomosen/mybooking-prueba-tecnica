module Policy
  class AllowedUnitsPolicy

    def initialize(time_measurement_mapper)
      @time_measurement_mapper = time_measurement_mapper
    end

    # Comprueba si la unidad de tiempo está comprendida entre las admitidas en la definción de precio
    def allowed?(price_definition:, time_measurement:, units:)
      list = allowed_units(price_definition: price_definition, time_measurement: time_measurement)
      return false if list.empty?
      list.include?(units.to_i)
    end

    # Devuelve las unidades de tiempo admitidas en la definición de precio
    def allowed_units(price_definition:, time_measurement:)
      field = "units_management_value_#{@time_measurement_mapper.from_db(time_measurement)}_list"
      return [] unless field && price_definition.respond_to?(field)

      raw = price_definition.public_send(field)
      parse_units_list(raw)
    end

    private

    # Parsea de string a array las unidades de tiempo admitidas en la definición de precio
    def parse_units_list(val)
      case val
      when String
        parts = val.split(/[,\s;]+/).map(&:strip).reject(&:empty?)
        parts.map!(&:to_i).uniq
      when Array
        val.map { |x| x.to_i }.uniq
      else
        []
      end
    end

  end
end
