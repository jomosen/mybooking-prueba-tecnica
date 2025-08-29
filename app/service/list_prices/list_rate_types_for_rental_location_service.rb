module Service
  module ListPrices
    class ListRateTypesForRentalLocationService

      def retrieve(params)

        sql = <<-SQL
          SELECT DISTINCT rt.id, rt.name
          FROM category_rental_location_rate_types crlrt
          JOIN rate_types rt ON rt.id = crlrt.rate_type_id
          WHERE crlrt.rental_location_id = ?
        SQL

        Infraestructure::Query.run(sql, params[:rental_location_id])
      end
      
    end
  end
end