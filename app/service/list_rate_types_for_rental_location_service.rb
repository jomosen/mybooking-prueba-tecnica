module Service
  class ListRateTypesForRentalLocationService

    def retrieve_by_rental_location(rental_location_id)

      sql = <<-SQL
        SELECT DISTINCT rt.id, rt.name
        FROM category_rental_location_rate_types crlrt
        JOIN rate_types rt ON rt.id = crlrt.rate_type_id
        WHERE crlrt.rental_location_id = ?
        ORDER BY rt.name ASC
      SQL

      Infraestructure::Query.run(sql, [rental_location_id])

    end
  end
end