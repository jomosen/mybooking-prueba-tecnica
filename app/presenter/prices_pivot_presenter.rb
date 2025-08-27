module Presenter
  class PricesPivotPresenter
    # rows: [{ "code"=>"A", "units"=>1, "price"=>"60.0" }, ...]
    def initialize(rows)
      @rows = rows
    end

    def as_table
      # 1) Columnas dinámicas a partir de units (ordenadas numéricamente)
      unit_cols = @rows.map { |r| r["units"].to_i }.uniq.sort

      # 2) Cabeceras: "Categoría" + unidades
      headers = ["Categoría"] + unit_cols.map(&:to_s)

      # 3) Agrupar por categoría y construir cada fila
      grouped = @rows.group_by { |r| r["code"] }

      table_rows = grouped.map do |code, items|
        by_units = items.each_with_object({}) do |r, h|
          h[r["units"].to_i] = r["price"].to_f
        end
        # Para cada columna de unidad, coloca el precio o nil/"-" si falta
        [code] + unit_cols.map { |u| by_units[u] }
      end

      { headers: headers, rows: table_rows }
    end
  end
end