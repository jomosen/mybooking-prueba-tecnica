module Service
  module ListPrices
    class ListSeasonsForSeasonDefinitionService
      
      def retrieve(params)

        sql = <<-SQL
          SELECT DISTINCT s.id, s.name
          FROM seasons s
          JOIN season_definitions sd ON sd.id = s.season_definition_id
          JOIN season_definition_rental_locations sdrl ON sd.id = sdrl.season_definition_id
          JOIN category_rental_location_rate_types crlrt ON crlrt.rental_location_id = sdrl.rental_location_id
          JOIN rate_types rt ON rt.id = crlrt.rate_type_id
          WHERE crlrt.rental_location_id = ? AND crlrt.rate_type_id = ? AND s.season_definition_id = ?
        SQL

        Infraestructure::Query.run(sql, params[:rental_location_id], params[:rate_type_id], params[:season_definition_id])
      end

    end
  end
end