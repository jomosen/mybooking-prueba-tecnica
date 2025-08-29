module Service
  module ImportPrices
                  
    class CsvDataSource < UseCase::Contract::ImportDataSource

      def initialize(file, row_mapper)
        @file = file
        @row_mapper = row_mapper
      end

      def read
        rows = []
        ::CSV.foreach(@file, headers: true, header_converters: :symbol) do |row|
          rows << @row_mapper.map(row)
        end
        rows
      rescue => e
        raise "Error al procesar CSV: #{e.message}"
      end
    end

  end
end