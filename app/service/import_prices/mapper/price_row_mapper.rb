module Service
  module ImportPrices
    module Mapper

      class PriceRowMapper
              
        def self.map(row)
          {
            category_id:        row[:category_id].to_i,
            rental_location_id: row[:rental_location_id].to_i,
            rate_type_id:       row[:rate_type_id].to_i,
            season_id:          row[:season_id].to_i,
            time_measurement:   row[:time_measurement].to_i,
            units:              row[:units].to_i,
            price:              row[:price].to_f,
            included_km:        row[:included_km].to_i,
            extra_km_price:     row[:extra_km_price].to_f
          }
        end
      end
    
    end
  end
end
