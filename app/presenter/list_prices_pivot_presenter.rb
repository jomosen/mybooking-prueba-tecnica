module Presenter
  # Transforma una lista de precios en una tabla pivotada:
  #   Input: [{ "code"=>"A", "units"=>"1", "price"=>"60.0" }, ...]
  #   Output: { headers: ["Categoría", "1", "2"], rows: [["A", 60.0, nil], ...] }
  #
  # Uso principal: preparar datos para mostrar en vistas (API/HTML).
  class ListPricesPivotPresenter
    def initialize(rows)
      @rows = rows
    end

    # Devuelve un hash con cabeceras y filas listas para mostrar en tabla
    def as_table
      unit_columns = extract_unit_columns
      headers      = build_headers(unit_columns)
      table_rows   = build_rows(group_by_category, unit_columns)

      { headers: headers, rows: table_rows }
    end

    private

    # Extrae las columnas dinámicas de unidades, ordenadas numéricamente
    def extract_unit_columns
      @rows.map { |r| r["units"].to_i }.uniq.sort
    end

    # Construye la cabecera de la tabla: "Categoría" seguida de las unidades de tiempo de la definición de precio
    def build_headers(unit_columns)
      ["Categoría"] + unit_columns.map(&:to_s)
    end

    # Agrupa las filas de entrada por código de categoría
    def group_by_category
      @rows.group_by { |r| r["code"] }
    end

    # Construye las filas de la tabla
    def build_rows(grouped_rows, unit_columns)
      grouped_rows.map do |code, items|
        # Mapea cada unidad a su precio
        prices_by_unit = items.each_with_object({}) do |row, hash|
          hash[row["units"].to_i] = row["price"].to_f
        end

        # Devuelve: [categoría, precio(unidad 1), precio(unidad 2), ...]
        [code] + unit_columns.map { |unit| prices_by_unit[unit] }
      end
    end
  end
end
