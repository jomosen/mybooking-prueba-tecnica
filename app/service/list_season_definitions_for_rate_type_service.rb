module Service
  class ListSeasonDefinitionsForRateTypeService

    def retrieve(params)

      sql = <<-SQL
        SELECT DISTINCT sd.id, sd.name
        FROM season_definitions sd
        JOIN season_definition_rental_locations sdrl ON sd.id = sdrl.season_definition_id
        JOIN category_rental_location_rate_types crlrt ON crlrt.rental_location_id = sdrl.rental_location_id
        JOIN rate_types rt ON rt.id = crlrt.rate_type_id
        WHERE crlrt.rate_type_id = ? AND crlrt.rental_location_id = ?
        ORDER BY sd.name ASC
      SQL

      Infraestructure::Query.run(sql, [params[:rate_type_id], params[:rental_location_id]])

    end
  end
end