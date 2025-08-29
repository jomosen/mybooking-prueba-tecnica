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
              • Advertencias: #{@r[:warnings].empty? ? "Ninguna" : @r[:warnings].join(", ")}
              • Errores: #{@r[:errors].empty? ? "Ninguno" : @r[:errors].join(", ")}
          MSG
        end
      end
      
    end
  end
end
