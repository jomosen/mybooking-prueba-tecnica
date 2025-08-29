module Repository
  class PriceRepository < Repository::BaseRepository

    def initialize
      super(Model::Price)
    end

    # Con upsert nos ahorramos tener que traer primero el precio: mejoramos rendimiento y atomicidad (lo hacemos en una sola operació atómica)
    def upsert(command)
      begin

        sql = <<-SQL
          INSERT INTO prices
            (price_definition_id, season_id, time_measurement, units, price, included_km, extra_km_price)
          VALUES
            (?, ?, ?, ?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE
            price         = VALUES(price),
            included_km   = VALUES(included_km),
            extra_km_price= VALUES(extra_km_price)
        SQL

        DataMapper.repository(:default).adapter.execute(sql, 
          command[:price_definition_id],
          command[:season_id],
          command[:time_measurement],
          command[:units],
          command[:price],
          command[:included_km],
          command[:extra_km_price])

      rescue => e
        raise e
      end
    end

  end
end
