module Service
  class ListPricesService

    def retrieve(params)
      conditions, values = build_conditions(params)

      sql = <<-SQL
        SELECT c.code, p.units, p.price
        FROM prices p
        JOIN price_definitions pd ON p.price_definition_id = pd.id
        LEFT JOIN season_definitions sd ON sd.id = pd.season_definition_id
        LEFT JOIN seasons s ON s.id = p.season_id
        JOIN category_rental_location_rate_types crlrt ON pd.id = crlrt.price_definition_id
        JOIN rental_locations rl ON crlrt.rental_location_id = rl.id
        JOIN rate_types rt ON crlrt.rate_type_id = rt.id
        JOIN categories c ON crlrt.category_id = c.id
        WHERE #{conditions.join(" AND ")}
      SQL

      Infraestructure::Query.run(sql, *values)
    end

    private

    def build_conditions(params)
      conditions = []
      values = []

      # rental_location_id (obligatorio)
      conditions << "rl.id = ?"
      values << params[:rental_location_id]

      # rate_type_id (obligatorio)
      conditions << "rt.id = ?"
      values << params[:rate_type_id]

      # season_definition_id
      if params[:season_definition_id].nil?
        conditions << "sd.id IS NULL"
      else
        conditions << "sd.id = ?"
        values << params[:season_definition_id]
      end

      # season_id
      if params[:season_id].nil?
        conditions << "s.id IS NULL"
      else
        conditions << "s.id = ?"
        values << params[:season_id]
      end

      # time_measurement (obligatorio)
      conditions << "p.time_measurement = ?"
      values << params[:time_measurement]

      [conditions, values]
    end

  end
end
