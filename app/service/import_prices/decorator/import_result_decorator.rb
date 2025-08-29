module Service
  module ImportPrices
    module Decorator
      
      class ImportResultDecorator

        def initialize(import_result)
          @r = import_result
        end

        def summary
          <<~MSG
            Importación finalizada:
              • Estado: #{@r[:success] ? "Éxito" : "Abortado"}
              • Última fila procesada: #{@r[:item_index] + 1}
              • Total de filas procesadas: #{@r[:processed]}
              • Filas saltadas: #{@r[:skipped]}
              • Advertencias: #{warnings_message}
              • Errores: #{errors_message}
          MSG
        end

        def warnings_message
          return "Ninguna" if @r[:warnings].empty?

          @r[:warnings].map do |w|
            "- Fila #{w[:item_index] + 1}: #{w[:detail]}"
          end.join("\n")
        end

        def errors_message
          return "Ninguno" if @r[:errors].empty?
          @r[:errors].map { |e| "- #{e}" }.join("\n")
        end
      end
      
    end
  end
end
