module Service
  module ImportPrices
      module Error

        class ImportAbortedError < StandardError

          attr_reader :item_index, :code, :detail

          def initialize(item_index:, code:, detail:)
            @item_index = item_index
            @code = code
            @detail = detail
            super("Import aborted at row #{item_index} with #{code}: #{detail}")
          end
          
        end
                  
      end
  end
end
